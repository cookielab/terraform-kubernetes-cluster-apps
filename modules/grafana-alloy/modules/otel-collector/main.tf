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
  stability_level       = var.stability_level
  host_network          = var.host_network
  ingress               = var.ingress
  tolerations           = var.tolerations
  node_selector         = var.node_selector
  pod_disruption_budget = var.pod_disruption_budget
  autoscaling           = var.autoscaling
  integrations = {
    otel_collector = true
  }
  otel = {
    endpoint                  = var.otel.endpoint
    tenant_id                 = var.otel.tenant_id
    http_port                 = var.otel.http_port
    grpc_port                 = var.otel.grpc_port
    service_graphs_dimensions = var.otel.service_graphs_dimensions
    span_metrics_dimensions   = var.otel.span_metrics_dimensions
    datadog_receiver_enabled  = var.otel.datadog_receiver_enabled
    datadog_port              = var.otel.datadog_port
    bearer_token              = var.otel.bearer_token
    logs_enabled              = var.otel.logs_enabled
  }
  loki = {
    url            = var.loki.url
    tenant_id      = var.loki.tenant_id
    auth_enabled   = var.loki.auth_enabled
    username       = var.loki.username
    password       = var.loki.password
    remote_timeout = var.loki.remote_timeout
  }
  config = concat(var.config, [<<-EOF
    otel_collector "default" {
    metrics_output  = prometheus.remote_write.default.receiver
    traces_output = sys.env("GRAFANA_ALLOY_OTEL_ENDPOINT")
    }
    EOF
  ])
}
