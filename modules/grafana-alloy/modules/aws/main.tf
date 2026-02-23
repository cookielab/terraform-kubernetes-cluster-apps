module "grafana_alloy" {
  source = "../../"

  agent_name           = "aws"
  agent_resources      = var.agent_resources
  clustering_enabled   = false
  chart_version        = var.chart_version
  controller_resources = var.controller_resources
  cluster_name         = var.cluster_name
  kubernetes_kind      = "deployment"
  namespace            = var.namespace
  image                = var.image
  metrics              = var.metrics
  replicas             = 1
  iam_role_arn         = var.iam_role_arn
  tolerations          = var.tolerations
  node_selector        = var.node_selector
  pod_disruption_budget = var.pod_disruption_budget
  integrations = {
    aws_opensearch = true
    aws_alb        = true
    aws_rds        = true
    aws_mq         = true
    aws_sqs        = true
  }
  otel = {
    enabled = false
  }
  config = concat(var.config, [<<-EOF
    aws_opensearch "default" {
      scrape_interval = "${var.aws_opensearch.scrape_interval}"
      scrape_timeout  = "${var.aws_opensearch.scrape_timeout}"
      scrape_period = "${var.aws_opensearch.scrape_period}"
      region = "${var.aws_opensearch.region}"
      metrics_output  = prometheus.remote_write.default.receiver
    }

    aws_alb "default" {
      scrape_interval = "${var.aws_alb.scrape_interval}"
      scrape_timeout  = "${var.aws_alb.scrape_timeout}"
      scrape_period   = "${var.aws_alb.scrape_period}"
      region          = "${var.aws_alb.region}"
      metrics_output  = prometheus.remote_write.default.receiver
      search_tags = {
        %{for k, v in var.aws_alb.search_tags}
        ${k} = "${v}",
        %{endfor}
      }
    }
    aws_rds "default" {
      scrape_interval = "${var.aws_alb.scrape_interval}"
      scrape_timeout  = "${var.aws_alb.scrape_timeout}"
      scrape_period = "${var.aws_alb.scrape_period}"
      region = "${var.aws_rds.region}"
      metrics_output  = prometheus.remote_write.default.receiver
      search_tags = {
        %{for k, v in var.aws_rds.search_tags}
        ${k} = "${v}",
        %{endfor}
      }
    }
    aws_mq "default" {
      scrape_interval = "${var.aws_mq.scrape_interval}"
      scrape_timeout  = "${var.aws_mq.scrape_timeout}"
      scrape_period = "${var.aws_mq.scrape_period}"
      region = "${var.aws_mq.region}"
      metrics_output  = prometheus.remote_write.default.receiver
      search_tags = {
        %{for k, v in var.aws_mq.search_tags}
        ${k} = "${v}",
        %{endfor}
      }
    }
    aws_sqs "default" {
      scrape_interval = "${var.aws_sqs.scrape_interval}"
      scrape_timeout  = "${var.aws_sqs.scrape_timeout}"
      scrape_period = "${var.aws_sqs.scrape_period}"
      region = "${var.aws_sqs.region}"
      metrics_output  = prometheus.remote_write.default.receiver
      search_tags = {
        %{for k, v in var.aws_sqs.search_tags}
        ${k} = "${v}",
        %{endfor}
      }
    }
    EOF
  ])
}
