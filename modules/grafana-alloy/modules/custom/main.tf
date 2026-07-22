module "grafana_alloy" {
  source = "../../"

  agent_name            = var.agent_name
  agent_resources       = var.agent_resources
  clustering_enabled    = var.clustering_enabled
  chart_version         = var.chart_version
  controller_resources  = var.controller_resources
  cluster_name          = var.cluster_name
  kubernetes_kind       = var.kubernetes_kind
  namespace             = var.namespace
  image                 = var.image
  metrics               = var.metrics
  replicas              = var.replicas
  iam_role_arn          = var.iam_role_arn
  tolerations           = var.tolerations
  node_selector         = var.node_selector
  host_network          = var.host_network
  ingress               = var.ingress
  pod_disruption_budget = var.pod_disruption_budget
  autoscaling           = var.autoscaling
  otel = {
    enabled = false
  }
  config = concat(var.config, var.custom_scrape_config)
}
