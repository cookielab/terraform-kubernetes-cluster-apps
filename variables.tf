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
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
    }), {})
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
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
    }), {})
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
    resources = optional(object({
      operator = optional(object({
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
      }), {})
      metrics_server = optional(object({
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
      }), {})
    }), {})
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
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
    }), {})
  })
  default = {}
}

variable "kyverno" {
  description = "kyverno configuration"
  type = object({
    namespace           = optional(string, "kyverno")
    create_namespace    = optional(bool, true)
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

variable "grafana_alloy" {
  description = "grafana alloy configuration"
  type = object({
    image = optional(object({
      repository = optional(string, "grafana/alloy")
    }), {})
    metrics = optional(object({
      endpoint    = optional(string, null)
      tenant      = optional(string, null)
      ssl_enabled = optional(bool, false)
      tenant_id   = optional(string, null)
    }), {})
    cluster = optional(object({
      enabled  = optional(bool, true)
      replicas = optional(number, 3)
      requests = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "256Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "256Mi")
      }), {})

    }), {})
    node = optional(object({
      enabled = optional(bool, true)
      requests = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "256Mi")
      }), {})
    }), {})
    loki = optional(object({
      enabled                = optional(bool, false)
      url                    = optional(string, null)
      tenant_id              = optional(string, "default")
      username               = optional(string, "")
      password               = optional(string, "")
      scrape_pods_global     = optional(bool, true)
      scrape_pods_annotation = optional(string, "")
      clustering_enabled     = optional(bool, false)
      scrape_logs_method     = optional(string, "api")
      replicas               = optional(number, 1)
    }), {})
    aws = optional(object({
      account = optional(string, "")
      region  = optional(string, "")
    }), {})
  })
  default = {}
  validation {
    condition     = contains(["file", "api"], var.grafana_alloy.loki.scrape_logs_method)
    error_message = "Valid values for loki.scrape_logs_method are \"file\" or \"api\"."
  }
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
    resources = optional(object({
      cert_manager = optional(object({
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
      }), {})
      cainjector = optional(object({
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
      }), {})
      webhook = optional(object({
        limits = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
        requests = optional(object({
          cpu    = optional(string)
          memory = optional(string)
        }), {})
      }), {})
    }), {})
  })
}

variable "fluent_bit" {
  description = "fluent bit configuration"
  type = object({
    enabled      = optional(bool, false)
    logs_storage = optional(string, "loki")
    loki = optional(object({
      tenant_id         = optional(string, null)
      logs_endpoint_url = optional(string, null)
      basic_auth = optional(object({
        enabled  = optional(bool, false)
        username = optional(string, null)
        password = optional(string, null)
      }), {})
      bearer_token = optional(object({
        enabled = optional(bool, false)
        token   = optional(string, null)
      }), {})
    }), {})
    elasticsearch = optional(object({
      auth = optional(object({
        enabled  = optional(bool, false)
        username = optional(string, null)
        password = optional(string, null)
      }), {})
    }), {})
    use_defaults = optional(object({
      outputs = optional(bool, true)
      filters = optional(bool, true)
      inputs  = optional(bool, true)
    }), {})
    logs_custom = optional(object({
      outputs = optional(map(string), {})
      filters = optional(map(string), {})
      inputs  = optional(map(string), {})
    }), {})
    logs_endpoint_url = optional(string, null)
    tolerations = optional(list(object({
      key      = string
      operator = string
      value    = string
      effect   = string
    })), [])
    node_selector   = optional(map(string), {})
    labels          = optional(map(string), {})
    pod_annotations = optional(map(string), {})
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }), {})
    }), {})
  })
  default = {}
}

variable "vpa" {
  description = "vpa configuration"
  type = object({
    enabled      = optional(bool, false)
    release_name = optional(string, "vpa")
    crds = optional(object({
      enabled = optional(bool, true)
    }), {})
    recommender = optional(object({
      enabled                 = optional(bool, true)
      replica_count           = optional(number, 1)
      service_account_enabled = optional(bool, true)
      resources = optional(object({
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
        requests = optional(object({
          cpu    = optional(string, "50m")
          memory = optional(string, "50Mi")
        }), {})
      }), {})
    }), {})
    updater = optional(object({
      enabled                 = optional(bool, true)
      replica_count           = optional(number, 1)
      service_account_enabled = optional(bool, true)
      resources = optional(object({
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
        requests = optional(object({
          cpu    = optional(string, "50m")
          memory = optional(string, "50Mi")
        }), {})
      }), {})
    }), {})
    admissionController = optional(object({
      enabled                 = optional(bool, true)
      replica_count           = optional(number, 1)
      service_account_enabled = optional(bool, true)
      resources = optional(object({
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
        requests = optional(object({
          cpu    = optional(string, "50m")
          memory = optional(string, "50Mi")
        }), {})
      }), {})
    }), {})
  })
  default = {}
}
