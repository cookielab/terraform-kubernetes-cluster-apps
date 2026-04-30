locals {
  karpenter_service_account_name = "cluster-karpenter-aws"
  karpenter_metrics_port         = "8080"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_eks_node_groups" "this" {
  cluster_name = data.aws_eks_cluster.this.name
}

data "aws_eks_node_group" "this" {
  for_each = data.aws_eks_node_groups.this.names

  cluster_name    = data.aws_eks_cluster.this.name
  node_group_name = each.value
}

resource "helm_release" "crds" {
  name      = "karpenter-crds"
  namespace = var.namespace

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter-crd"
  version    = "1.11.1"
}

data "aws_iam_policy_document" "iam_pass_role" {
  count = var.node_role_arn != null ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [var.node_role_arn]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "iam_pass_role" {
  count = var.node_role_arn != null ? 1 : 0

  name   = "${data.aws_eks_cluster.this.name}-karpenter-node"
  policy = data.aws_iam_policy_document.iam_pass_role[0].json
}

moved {
  from = aws_iam_policy.iam_pass_role
  to   = aws_iam_policy.iam_pass_role[0]
}

data "aws_iam_policy_document" "karpenter_controller" {
  statement {
    actions = [
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateTags",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "pricing:GetProducts",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${var.tag_key}"
      values   = [data.aws_eks_cluster.this.name]
    }
  }

  statement {
    actions = ["ec2:RunInstances"]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:launch-template/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${var.tag_key}"
      values   = [data.aws_eks_cluster.this.name]
    }
  }

  statement {
    actions = ["ec2:RunInstances"]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*::image/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:spot-instances-request/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:volume/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:network-interface/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:${data.aws_caller_identity.current.account_id}:subnet/*",
    ]
  }

  statement {
    actions   = ["ssm:GetParameter"]
    resources = ["arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/aws/service/*"]
  }

  statement {
    actions = ["iam:PassRole"]
    resources = concat(
      [for node_group in data.aws_eks_node_group.this : node_group.node_role_arn],
      ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${data.aws_eks_cluster.this.name}-karpenter-*"]
    )
  }

  statement {
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetInstanceProfile",
      "iam:ListInstanceProfiles",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:${data.aws_partition.current.partition}:eks:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:cluster/${data.aws_eks_cluster.this.name}"]
  }

  dynamic "statement" {
    for_each = var.enable_disruption ? [1] : []

    content {
      actions = [
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ReceiveMessage",
      ]
      resources = [aws_sqs_queue.disruption[0].arn]
    }
  }
}

resource "aws_iam_policy" "karpenter_controller" {
  name   = "${data.aws_eks_cluster.this.name}-karpenter-controller"
  policy = data.aws_iam_policy_document.karpenter_controller.json
}

module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "6.5.0"

  name            = "karpenter-${data.aws_eks_cluster.this.name}"
  use_name_prefix = false
  description     = "IRSA role for karpenter"

  policies = merge(
    { karpenter_controller = aws_iam_policy.karpenter_controller.arn },
    var.node_role_arn == null ? {} : { node_pass_role = aws_iam_policy.iam_pass_role[0].arn }
  )

  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = ["${var.namespace}:${local.karpenter_service_account_name}"]
    }
  }
}

resource "helm_release" "this" {
  name      = "karpenter"
  namespace = var.namespace

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.11.1"

  values = [yamlencode({
    replicas     = var.replicas
    nodeSelector = var.node_selector
    tolerations  = var.tolerations

    serviceAccount = {
      name = local.karpenter_service_account_name
      annotations = {
        "eks.amazonaws.com/role-arn" = module.irsa.arn
      }
    }

    controller = {
      image = {
        repository = var.repository
      }
      metrics = {
        port = local.karpenter_metrics_port
      }
      resources = var.resources
    }

    settings = {
      clusterName       = data.aws_eks_cluster.this.name
      clusterEndpoint   = data.aws_eks_cluster.this.endpoint
      interruptionQueue = var.enable_disruption ? aws_sqs_queue.disruption[0].name : null

      batchMaxDuration  = var.batch_max_duration
      batchIdleDuration = var.batch_idle_duration

      featureGates = {
        spotToSpotConsolidation = var.spot_to_spot_consolidation
      }
    }

    podAnnotations = merge({
      "prometheus.io/port" = local.karpenter_metrics_port
      "prometheus.io/path" = "/metrics"
    }, var.pod_annotations)
  })]
}
