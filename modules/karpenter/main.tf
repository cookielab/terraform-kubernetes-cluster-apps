locals {
  karpenter_service_account_name = "cluster-karpenter-aws"
  karpenter_metrics_port         = "8080"
}

data "aws_caller_identity" "current" {}

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
  version    = "1.1.0"
}

module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.48.0"

  role_name_prefix = "karpenter-${data.aws_eks_cluster.this.name}"
  role_description = "IRSA role for karpenter"

  attach_karpenter_controller_policy         = true
  enable_karpenter_instance_profile_creation = true

  karpenter_controller_cluster_name       = data.aws_eks_cluster.this.name
  karpenter_controller_node_iam_role_arns = concat([for node_group in data.aws_eks_node_group.this : node_group.node_role_arn], ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.aws_eks_cluster.this.name}-karpenter-*"])
  karpenter_tag_key                       = var.tag_key
  karpenter_sqs_queue_arn                 = var.enable_disruption ? aws_sqs_queue.disruption[0].arn : null

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
  version    = "1.1.0"

  values = [yamlencode({
    replicas     = var.replicas
    nodeSelector = var.node_selector
    tolerations  = var.tolerations

    serviceAccount = {
      name = local.karpenter_service_account_name
      annotations = {
        "eks.amazonaws.com/role-arn" = module.irsa.iam_role_arn
      }
    }

    controller = {
      image = {
        repository = var.repository
      }
      metrics = {
        port = local.karpenter_metrics_port
      }
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