output "otel_endpoints" {
  value = var.integrations.otel_collector ? {
    grpc    = "${local.agent_name}.${var.namespace}:${var.otel.grpc_port}"
    http    = "http://${local.agent_name}.${var.namespace}:${var.otel.http_port}"
    traces  = "http://${local.agent_name}.${var.namespace}:${var.otel.http_port}/v1/traces"
    metrics = "http://${local.agent_name}.${var.namespace}:${var.otel.http_port}/v1/metrics"
    } : {
    grpc    = null
    http    = null
    traces  = null
    metrics = null
  }
  description = "Exposed OTel endpoints"
}
