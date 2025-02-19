resource "helm_release" "keda" {
  name       = "keda"
  repository = var.repository
  chart      = "keda"
  namespace  = var.namespace
  version    = "2.16.1"

  values = [
    yamlencode({
      replicas       = var.replicas
      logLevel       = var.log_level
      metricsServer  = { enabled = var.metrics_server }
      nodeSelector   = var.node_selector
      tolerations    = var.tolerations
      podAnnotations = var.pod_annotations
    })
  ]
}

