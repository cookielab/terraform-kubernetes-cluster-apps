resource "helm_release" "grafana_alloy" {
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  version    = var.chart_version
  name       = local.agent_name
  namespace  = var.namespace
  timeout    = 600

  values = [yamlencode({
    image = var.image
    controller = {
      type      = var.kubernetes_kind
      resources = var.controller_resources
      replicas  = var.replicas
      podDisruptionBudget = {
        enabled        = var.pod_disruption_budget.enabled
        minAvailable   = var.pod_disruption_budget.min_available
        maxUnavailable = var.pod_disruption_budget.max_unavailable
      }
      volumes = {
        extra = [for volume in var.host_volumes : {
          name = volume.name
          hostPath = {
            path = volume.host_path
          }
        }]
      }
      tolerations  = var.tolerations
      nodeSelector = var.node_selector
    }
    alloy = merge(var.integrations.otel_collector ? { extraPorts = [
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
      }]
      } : {}, {
      mode = "flow"
      liveDebug = {
        enabled = var.live_debug
      }
      securityContext = var.kubernetes_security_context
      clustering = {
        enabled = var.clustering_enabled
      }
      stabilityLevel = var.stability_level
      configMap = {
        create = false
        name   = kubernetes_config_map_v1.grafana_alloy.metadata[0].name
        key    = local.agent_config_key
      }
      resources = local.agent_resources
      envFrom = [{
        secretRef = {
          name = kubernetes_secret_v1.grafana_alloy.metadata[0].name
        }
      }]
      mounts = {
        extra = [for mount in var.host_volumes : {
          name      = mount.name
          mountPath = mount.mount_path
        }]
      }
    })
    }),
    var.iam_role_arn != "" ? yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.iam_role_arn
        }
      }
    }) : yamlencode({})
  ]
}
