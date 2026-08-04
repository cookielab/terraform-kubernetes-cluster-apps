resource "helm_release" "grafana_alloy" {
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  version    = var.chart_version
  name       = local.agent_name
  namespace  = var.namespace
  timeout    = 600

  values = [yamlencode({
    image = var.image
    controller = merge({
      type        = var.kubernetes_kind
      resources   = var.controller_resources
      replicas    = var.replicas
      hostNetwork = var.host_network != null ? var.host_network : (var.kubernetes_kind == "daemonset")
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
      }, var.clustering_enabled ? {
      autoscaling = {
        enabled                        = true
        minReplicas                    = var.autoscaling.min_replicas
        maxReplicas                    = var.autoscaling.max_replicas
        targetCPUUtilizationPercentage = var.autoscaling.target_cpu_utilization_percentage
      }
    } : {})
    alloy = merge(length(local.alloy_extra_ports) > 0 ? {
      extraPorts = local.alloy_extra_ports
      } : {}, {
      mode = "flow"
      liveDebug = {
        enabled = var.live_debug
      }
      securityContext = var.kubernetes_security_context
      clustering = {
        enabled = var.clustering_enabled
      }
      stabilityLevel = local.stability_level
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
    ingress = merge({
      enabled     = var.ingress.enabled
      annotations = var.ingress.annotations
      labels      = var.ingress.labels
      path        = var.ingress.path
      faroPort    = var.ingress.port
      pathType    = var.ingress.path_type
      hosts       = var.ingress.hosts
      extraPaths  = var.ingress.extra_paths
      tls = [for tls in var.ingress.tls : {
        secretName = tls.secret_name
        hosts      = tls.hosts
      }]
      }, var.ingress.ingress_class_name != null ? {
      ingressClassName = var.ingress.ingress_class_name
    } : {})
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
