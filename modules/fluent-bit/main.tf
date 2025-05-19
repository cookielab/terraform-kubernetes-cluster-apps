resource "helm_release" "fluentbit" {
  name       = "fluentbit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = "0.48.9"
  namespace  = var.namespace

  values = [yamlencode({
    config = {
      inputs = templatefile("${path.module}/config/inputs.tftpl", {
        logs_custom  = var.logs_custom.inputs
        use_defaults = var.use_defaults
      })
      filters = templatefile("${path.module}/config/filters.tftpl", {
        logs_custom  = var.logs_custom.filters
        use_defaults = var.use_defaults
      })
      outputs = templatefile("${path.module}/config/outputs.tftpl", {
        logs_custom       = var.logs_custom.outputs
        use_defaults      = var.use_defaults
        logs_storage      = var.logs_storage
        logs_endpoint_url = var.logs_endpoint_url
        elasticsearch     = var.elasticsearch
        loki              = var.loki
      })
    }
  })]
}

