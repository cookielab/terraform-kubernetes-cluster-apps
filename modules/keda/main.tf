resource "helm_release" "keda" {
  name       = "keda"
  repository = var.repository
  chart      = "keda"
  namespace  = var.namespace
  version    = "2.16.1"

  values = [
    yamlencode({
      replicas = var.replicas
      logLevel = var.log_level
      metricsServer = {
        enabled = var.metrics_server
      }
      nodeSelector   = var.node_selector
      tolerations    = var.tolerations
      podAnnotations = var.pod_annotations
      serviceAccount = {
        operator = {
          annotations = var.role_arn != null ? { "eks.amazonaws.com/role-arn" = var.role_arn } : {}
        }
      }
      resources = {
        operator     = var.resources.operator
        metricServer = var.resources.metricServer
        webhooks     = var.resources.webhooks
      }
    })
  ]
}

