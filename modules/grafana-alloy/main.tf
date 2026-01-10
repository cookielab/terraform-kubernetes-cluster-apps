locals {
  agent_name        = format("grafana-alloy-%s", var.agent_name)
  agent_config_key  = "config.river"
  url_metrics_write = var.metrics.backend_type == "mimir" ? format("%s://%s/api/v1/push", var.metrics.ssl_enabled ? "https" : "http", trimsuffix(var.metrics.endpoint, "/")) : format("%s://%s/api/v1/write", var.metrics.ssl_enabled ? "https" : "http", trimsuffix(var.metrics.endpoint, "/"))
  url_mimir_rules   = trimsuffix(var.metrics.endpoint, "/")

  agent_resources = {
    requests = {
      cpu    = var.agent_resources.requests.cpu
      memory = var.agent_resources.requests.memory
    }
    limits = {
      cpu    = var.agent_resources.limits.cpu == null ? var.agent_resources.requests.cpu : var.agent_resources.limits.cpu
      memory = var.agent_resources.limits.memory == null ? var.agent_resources.requests.memory : var.agent_resources.limits.memory
    }
  }
}
