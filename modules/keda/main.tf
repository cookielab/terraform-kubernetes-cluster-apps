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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1498318 (fix: consistency)
      metricsServer = merge(
        { enabled = var.metrics_server },
        length(var.resources.metrics_server) > 0 ? { resources = var.resources.metrics_server } : {}
      )
<<<<<<< HEAD
=======
      metricsServer = length(var.resources.metrics_server) > 0 ? {
        enabled   = var.metrics_server
        resources = var.resources.metrics_server
        } : {
        enabled = var.metrics_server
      }
>>>>>>> ff995d1 (feat(cluster-apps) enable resources and limits in all modules)
=======
>>>>>>> 1498318 (fix: consistency)
      nodeSelector   = var.node_selector
      tolerations    = var.tolerations
      podAnnotations = var.pod_annotations
      serviceAccount = {
        operator = {
          annotations = merge(var.role_arn != null ? { "eks.amazonaws.com/role-arn" = var.role_arn } : {}, {})
        }
      }
    }, length(var.resources.operator) > 0 ? { resources = var.resources.operator } : {}))
  ]
}
