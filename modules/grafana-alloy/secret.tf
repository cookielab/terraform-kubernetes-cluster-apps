resource "kubernetes_secret_v1" "grafana_alloy" {
  metadata {
    name      = local.agent_name
    namespace = var.namespace
  }

  data = merge(var.envs,
    var.integrations.otel_collector ? merge(
      { GRAFANA_ALLOY_OTEL_ENDPOINT = var.otel.endpoint },
      var.otel.tenant_id != null ? { GRAFANA_ALLOY_OTEL_TENANT = var.otel.tenant_id } : {},
      var.otel.bearer_token != null ? { GRAFANA_ALLOY_OTLP_BEARER_TOKEN = var.otel.bearer_token } : {}
    ) : {},
    (var.integrations.loki_logs || (var.integrations.otel_collector && var.otel.logs_enabled)) ? {
      LOKI_URL       = var.loki.url
      LOKI_TENANT_ID = var.loki.tenant_id
      LOKI_USERNAME  = var.loki.username
      LOKI_PASSWORD  = var.loki.password
      AWS_ACCOUNT    = var.aws.account
      AWS_REGION     = var.aws.region
      CLUSTER_NAME   = var.cluster_name
    } : {},
    merge(
      {
        GRAFANA_ALLOY_METRICS_ENDPOINT     = local.url_metrics_write
        GRAFANA_ALLOY_MIMIR_RULES_ENDPOINT = local.url_mimir_rules
        GRAFANA_ALLOY_METRICS_TENANT       = var.metrics.tenant
        GRAFANA_ALLOY_K8S_CLUSTER          = var.cluster_name
      },
      var.metrics.bearer_token != null ? { GRAFANA_ALLOY_METRICS_BEARER_TOKEN = var.metrics.bearer_token } : {},
      var.metrics.username != null ? { GRAFANA_ALLOY_METRICS_USERNAME = var.metrics.username } : {},
      var.metrics.password != null ? { GRAFANA_ALLOY_METRICS_PASSWORD = var.metrics.password } : {}
    )
  )
}

