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

  deltatocumulative_enabled = var.integrations.otel_collector
  stability_level           = local.deltatocumulative_enabled ? "experimental" : var.stability_level

  otel_extra_ports = var.integrations.otel_collector ? concat(
    [
      {
        name       = "http-otel"
        targetPort = var.otel.http_port
        port       = var.otel.http_port
        protocol   = "TCP"
      },
      {
        name       = "grpc-otel"
        targetPort = var.otel.grpc_port
        port       = var.otel.grpc_port
        protocol   = "TCP"
      }
    ],
    var.otel.datadog_receiver_enabled ? [
      {
        name       = "datadog"
        targetPort = var.otel.datadog_port
        port       = var.otel.datadog_port
        protocol   = "TCP"
      }
    ] : []
  ) : []

  ingress_extra_ports = var.ingress.enabled && var.ingress.port != 12345 && !contains([for port in local.otel_extra_ports : port.port], var.ingress.port) ? [
    {
      name       = format("ingress-%d", var.ingress.port)
      targetPort = var.ingress.port
      port       = var.ingress.port
      protocol   = "TCP"
    }
  ] : []

  alloy_extra_ports = concat(local.otel_extra_ports, local.ingress_extra_ports)
}
