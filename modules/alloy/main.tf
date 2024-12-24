locals {
  node_agent_service_account    = "grafana-alloy-node-agent"
  cluster_agent_service_account = "grafana-alloy-cluster-agent"
  node_template_file_path       = var.node_template_file_path == null ? "${path.module}/resources/node-grafana-alloy.tmpl" : var.node_template_file_path
  cluster_template_file_path    = var.cluster_template_file_path == null ? "${path.module}/resources/cluster-grafana-alloy.tmpl" : var.cluster_template_file_path
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "helm_release" "node" {
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  name       = "node-agent"
  namespace  = var.namespace
  version    = "0.10.1"
  values = [
    yamlencode({
      alloy = {
        configMap = {
          create = true
          content = templatefile(local.node_template_file_path, {
            loki_scrape_global  = var.loki_scrape_global
            loki_url            = var.loki.url
            loki_username       = var.loki.username
            loki_password       = var.loki.password
            tenant_id           = var.tenant_id
            cluster_name        = var.cluster_name
            aws_account         = data.aws_caller_identity.current.account_id
            aws_region          = data.aws_region.current.name
            prometheus_url      = var.prometheus.url
            prometheus_username = var.prometheus.username
            prometheus_password = var.prometheus.password
            project             = var.project
          })
        }
        mounts = {
          dockercontainers = true
          varlog           = true
          extra = [
            {
              name      = "rootfs"
              mountPath = "/host/root"
            },
            {
              name      = "sysfs"
              mountPath = "/host/sys"
            },
            {
              name      = "procfs"
              mountPath = "/host/proc"
            }
          ]
        }
      }
      controller = {
        podAnnotations = {
          "loki.grafana.com/scrape"       = tostring(var.loki_collect_self_logs_enabled)
          "ad.datadoghq.com/logs_exclude" = "true"
        }
        volumes = {
          extra = [
            {
              name = "rootfs"
              hostPath = {
                path = "/root"
              }
            },
            {
              name = "sysfs"
              hostPath = {
                path = "/sys"
              }
            },
            {
              name = "procfs"
              hostPath = {
                path = "/proc"
              }
            }
          ]
        }
        type = "daemonset"
        securityContext = {
          privileged = true
          runAsUser  = 0
        }
        serviceAccount = {
          server = {
            name = local.node_agent_service_account
          }
        }
      }
    })
  ]
  timeout = 900
}

resource "helm_release" "cluster" {
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  name       = "cluster-agent"
  namespace  = var.namespace
  version    = "0.10.1"
  values = [
    yamlencode({
      controller = {
        type = "deployment"
        podAnnotations = {
          "loki.grafana.com/scrape"       = tostring(var.loki_collect_self_logs_enabled)
          "ad.datadoghq.com/logs_exclude" = "true"
        }
      }
      alloy = {
        configMap = {
          create = true
          content = templatefile(local.cluster_template_file_path, {
            tenant_id           = var.tenant_id
            loki_url            = var.loki.url
            loki_username       = var.loki.username
            loki_password       = var.loki.password
            cluster_name        = var.cluster_name
            aws_account         = data.aws_caller_identity.current.account_id
            aws_region          = data.aws_region.current.name
            prometheus_url      = var.prometheus.url
            prometheus_username = var.prometheus.username
            prometheus_password = var.prometheus.password
            project             = var.project
          })
        }
        securityContext = {
          runAsUser  = 0
          privileged = true
        }
      }
      serviceAccount = {
        server = {
          name = local.cluster_agent_service_account
        }
      }
    })
  ]
  timeout = 900
}
