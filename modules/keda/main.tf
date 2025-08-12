resource "helm_release" "keda" {
  name       = "keda"
  repository = var.repository
  chart      = "keda"
  namespace  = var.namespace
  version    = "2.16.1"

  values = [
    yamlencode(merge({
      replicas = var.replicas
      logLevel = var.log_level
      metricsServer = merge(
        { enabled = var.metrics_server },
        length(var.resources.metricServer) > 0 ? { resources = var.resources.metricServer } : {}
      )
      nodeSelector   = var.node_selector
      tolerations    = var.tolerations
      podAnnotations = var.pod_annotations
      serviceAccount = {
        operator = {
          annotations = merge(var.role_arn != null ? { "eks.amazonaws.com/role-arn" = var.role_arn } : {}, {})
        }
      }
      },
      (length(var.resources.operator) > 0 || length(var.resources.webhooks) > 0)
      ? {
        resources = merge(
          {},
          length(var.resources.operator) > 0 ? { operator = var.resources.operator } : {},
          length(var.resources.webhooks) > 0 ? { webhooks = var.resources.webhooks } : {}
        )
      } : {}
    ))
  ]
}
