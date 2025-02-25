variable "namespace" {
  description = "value of the namespace to deploy cluster apps"
  type = object({
    name   = string
    create = bool
  })
  default = {
    name   = "cluster-apps"
    create = true
  }
}

variable "cluster_name" {
  description = "name of the EKS cluster"
  type        = string
}

variable "project" {
  default = "project name"
  type    = string
}

variable "node_selector" {
  description = "node selector to deploy cluster apps"
  type        = map(string)
  default = {
    "node.kubernetes.io/pool" = "critical"
  }
}

variable "tolerations" {
  description = "tolerations to deploy cluster apps"
  type = list(object({
    key      = string
    operator = string
    value    = optional(string, null)
    effect   = optional(string, null)
  }))
  default = [{
    key      = "CriticalAddonsOnly"
    operator = "Exists"
    effect   = "NoSchedule"
  }]
}

variable "metrics_server" {
  description = "metrics server configuration"
  type = object({
    enabled       = optional(bool, true)
    repository    = optional(string, "registry.k8s.io/metrics-server/metrics-server")
    node_selector = optional(map(string), null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = optional(string, null)
      effect   = optional(string, null)
    })), null)
  })
  default = {}
}

variable "karpenter" {
  description = "karperter configuration"
  type = object({
    enabled       = optional(bool, true)
    repository    = optional(string, "public.ecr.aws/karpenter/controller")
    node_selector = optional(map(string), null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = optional(string, null)
      effect   = optional(string, null)
    })), null)
    replicas                   = optional(number, 2)
    tag_key                    = optional(string, "eks:eks-cluster-name")
    enable_disruption          = optional(bool, true)
    batch_max_duration         = optional(string, "10s")
    batch_idle_duration        = optional(string, "1s")
    spot_to_spot_consolidation = optional(bool, false)
    pod_annotations            = optional(map(string), {})
    node_role_arn              = optional(string, null)
  })
  default = {}
}

variable "keda" {
  description = "Keda configuration"
  type = object({
    enabled        = optional(bool, false)
    repository     = optional(string, "https://kedacore.github.io/charts")
    namespace      = optional(string, "cluster-apps")
    replicas       = optional(number, 2)
    log_level      = optional(string, "info")
    metrics_server = optional(bool, true)
    node_selector  = optional(map(string), {})
    role_arn       = optional(string, null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = optional(string, null)
      effect   = optional(string, null)
    })), [])
    pod_annotations = optional(map(string), {})
  })
  default = {}
}

variable "external_secrets" {
  description = "external secrets configuration"
  type = object({
    enabled       = optional(bool, true)
    repository    = optional(string, "oci.external-secrets.io/external-secrets/external-secrets")
    node_selector = optional(map(string), null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = optional(string, null)
      effect   = optional(string, null)
    })), null)
  })
  default = {}
}

variable "kyverno" {
  description = "kyverno configuration"
  type = object({
    enabled             = optional(bool, false)
    registry            = optional(string, "ghcr.io")
    docker_hub_registry = optional(string, "docker.io")
    node_selector       = optional(map(string), null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = optional(string, null)
      effect   = optional(string, null)
    })), null)
    admission_controller = optional(
      object(
        {
          replicas = optional(number, 2)
          container = optional(object(
            {
              resources = object({
                requests = object({
                  cpu    = optional(string, "300m")
                  memory = optional(string, "384Mi")
                }),
                limits = object({
                  memory = optional(string, "384Mi")
                })
              })
            }
            ),
            {
              resources = {
                requests = {
                  cpu    = "300m"
                  memory = "384Mi"
                }
                limits = {
                  memory = "384Mi"
                }
              }
            }
          )
        }
      ),
      {
        replicas = 2
        container = {
          resources = {
            requests = {
              cpu    = "300m"
              memory = "384Mi"
            }
            limits = {
              memory = "384Mi"
            }
          }
        }
      }
    )
  })
  default = {}
}

variable "alloy" {
  description = "grafana alloy configuration"
  type = object({
    enabled = optional(bool, true)
    loki = optional(
      object({
        url      = string
        username = optional(string, null)
        password = optional(string, null)
      }),
      {
        url      = null
        username = null
        password = null
      }
    )
    loki_scrape_global             = optional(bool, true)
    loki_collect_self_logs_enabled = optional(bool, false)
    prometheus = optional(
      object({
        url      = string
        username = optional(string, null)
        password = optional(string, null)
      }),
      {
        url      = null
        username = null
        password = null
      }
    )
    tenant_id                  = optional(string, "default")
    node_template_file_path    = optional(string, null)
    cluster_template_file_path = optional(string, null)
  })
}

variable "cert_manager" {
  description = "cert manager configuration"
  type = object({
    enabled       = optional(bool, false)
    node_selector = optional(map(string), null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = optional(string, null)
      effect   = optional(string, null)
    })), null)
  })
}
