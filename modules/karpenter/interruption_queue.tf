locals {
  disruption_events = var.enable_disruption ? {
    "health-event"          = jsonencode({ source = ["aws.health"], "detail-type" = ["AWS Health Event"] })
    "spot-interruption"     = jsonencode({ source = ["aws.ec2"], "detail-type" : ["EC2 Spot Instance Interruption Warning"] })
    "instance-state-change" = jsonencode({ source = ["aws.ec2"], "detail-type" : ["EC2 Instance State-change Notification"] })
    "rebalance"             = jsonencode({ source = ["aws.ec2"], "detail-type" : ["EC2 Instance Rebalance Recommendation"] })
  } : {}
}

resource "aws_sqs_queue" "disruption" {
  count = var.enable_disruption ? 1 : 0

  name_prefix               = "karpenter-disruption-${data.aws_eks_cluster.this.name}"
  message_retention_seconds = 300
}

data "aws_iam_policy_document" "disruption_sqs" {
  count = var.enable_disruption ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "sqs.amazonaws.com"
      ]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.disruption[0].arn]
  }
}

resource "aws_sqs_queue_policy" "disruption" {
  count = var.enable_disruption ? 1 : 0

  queue_url = aws_sqs_queue.disruption[0].id
  policy    = data.aws_iam_policy_document.disruption_sqs[0].json
}

resource "aws_cloudwatch_event_rule" "disruption_events" {
  for_each = local.disruption_events

  name          = "karpenter-${each.key}-${data.aws_eks_cluster.this.name}"
  event_pattern = each.value
}

resource "aws_cloudwatch_event_target" "disruption_events" {
  for_each = local.disruption_events

  rule = aws_cloudwatch_event_rule.disruption_events[each.key].name
  arn  = aws_sqs_queue.disruption[0].arn
}


