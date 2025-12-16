module "grafana_alloy" {
  source = "../../"

  agent_name           = "custom-scrape"
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
  otel = {
    enabled = false
  }
  config = concat(var.config, var.custom_scrape_config)
}
