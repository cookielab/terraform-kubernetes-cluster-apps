## Example usage
```hcl
module "cluster_apps" {
  source  = "cookielab/cluster-apps/kubernetes"
  version = "1.5.0"

  namespace = {
    create = true
    name   = "cluster-apps"
  }

  cluster_name = "<cluster_name>"

  node_selector = {}

  grafana_alloy = {
    metrics = {
      endpoint = "<mimir_http_endpoint>"
      ssl_enabled = false
    }
    loki = {
      enabled = true
      url = "http://loki:3100/loki/api/v1/push"
    }
    aws = {
      account = data.aws_caller_identity.current.account_id
      region  = data.aws_region.current.name
    }
  }

  cert_manager = {
    enabled = true
  }

  external_secrets = {
    enabled = false
  }

  karpenter = {
    enabled = false
  }

  kyverno = {
    enabled = false
  }

  vpa = {
    enabled = false
  }

  metrics_server = {
    enabled = true
    node_selector = {
      "node-role.kubernetes.io/control-plane" = ""
    }
    tolerations = [
      {
        key      = "CriticalAddonsOnly"
        operator = "Exists"
      },
      {
        key      = "node-role.kubernetes.io/control-plane"
        operator = "Exists"
      }
    ]
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.27 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_external_secrets"></a> [external\_secrets](#module\_external\_secrets) | ./modules/external-secrets | n/a |
| <a name="module_fluent-bit"></a> [fluent-bit](#module\_fluent-bit) | ./modules/fluent-bit | n/a |
| <a name="module_grafana_alloy_cluster"></a> [grafana\_alloy\_cluster](#module\_grafana\_alloy\_cluster) | cookielab/grafana-alloy/kubernetes//modules/cluster | v0.0.6 |
| <a name="module_grafana_alloy_loki"></a> [grafana\_alloy\_loki](#module\_grafana\_alloy\_loki) | cookielab/grafana-alloy/kubernetes//modules/loki-logs | v0.0.6 |
| <a name="module_grafana_alloy_node"></a> [grafana\_alloy\_node](#module\_grafana\_alloy\_node) | cookielab/grafana-alloy/kubernetes//modules/node | v0.0.6 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ./modules/karpenter | n/a |
| <a name="module_keda"></a> [keda](#module\_keda) | ./modules/keda | n/a |
| <a name="module_kyverno"></a> [kyverno](#module\_kyverno) | ./modules/kyverno | n/a |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | ./modules/metrics-server | n/a |
| <a name="module_vpa"></a> [vpa](#module\_vpa) | ./modules/vpa | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | cert manager configuration | <pre>object({<br/>    enabled       = optional(bool, false)<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    resources = optional(object({<br/>      cert_manager = optional(object({<br/>        replicas = optional(number, 1)<br/>        limits = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>      }), {})<br/>      cainjector = optional(object({<br/>        replicas = optional(number, 1)<br/>        limits = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>      }), {})<br/>      webhook = optional(object({<br/>        replicas = optional(number, 1)<br/>        limits = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of the EKS cluster | `string` | n/a | yes |
| <a name="input_external_secrets"></a> [external\_secrets](#input\_external\_secrets) | external secrets configuration | <pre>object({<br/>    enabled       = optional(bool, true)<br/>    repository    = optional(string, "oci.external-secrets.io/external-secrets/external-secrets")<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    resources = optional(object({<br/>      replicas = optional(number, 1)<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }), {})<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }), {})<br/>    }), {})<br/>    webhook = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    certController = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string)<br/>          memory = optional(string)<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_fluent_bit"></a> [fluent\_bit](#input\_fluent\_bit) | fluent bit configuration | <pre>object({<br/>    enabled      = optional(bool, false)<br/>    logs_storage = optional(string, "loki")<br/>    loki = optional(object({<br/>      tenant_id         = optional(string, null)<br/>      logs_endpoint_url = optional(string, null)<br/>      basic_auth = optional(object({<br/>        enabled  = optional(bool, false)<br/>        username = optional(string, null)<br/>        password = optional(string, null)<br/>      }), {})<br/>      bearer_token = optional(object({<br/>        enabled = optional(bool, false)<br/>        token   = optional(string, null)<br/>      }), {})<br/>    }), {})<br/>    elasticsearch = optional(object({<br/>      auth = optional(object({<br/>        enabled  = optional(bool, false)<br/>        username = optional(string, null)<br/>        password = optional(string, null)<br/>      }), {})<br/>    }), {})<br/>    use_defaults = optional(object({<br/>      outputs = optional(bool, true)<br/>      filters = optional(bool, true)<br/>      inputs  = optional(bool, true)<br/>    }), {})<br/>    logs_custom = optional(object({<br/>      outputs = optional(map(string), {})<br/>      filters = optional(map(string), {})<br/>      inputs  = optional(map(string), {})<br/>    }), {})<br/>    logs_endpoint_url = optional(string, null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = string<br/>      effect   = string<br/>    })), [])<br/>    node_selector   = optional(map(string), {})<br/>    labels          = optional(map(string), {})<br/>    pod_annotations = optional(map(string), {})<br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }), {})<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_grafana_alloy"></a> [grafana\_alloy](#input\_grafana\_alloy) | grafana alloy configuration | <pre>object({<br/>    image = optional(object({<br/>      repository = optional(string, "grafana/alloy")<br/>    }), {})<br/>    metrics = optional(object({<br/>      endpoint    = optional(string, null)<br/>      tenant      = optional(string, null)<br/>      ssl_enabled = optional(bool, false)<br/>      tenant_id   = optional(string, null)<br/>    }), {})<br/>    cluster = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 3)<br/>      requests = optional(object({<br/>        cpu    = optional(string, "100m")<br/>        memory = optional(string, "256Mi")<br/>      }), {})<br/>      limits = optional(object({<br/>        cpu    = optional(string, "100m")<br/>        memory = optional(string, "256Mi")<br/>      }), {})<br/><br/>    }), {})<br/>    node = optional(object({<br/>      enabled = optional(bool, true)<br/>      requests = optional(object({<br/>        cpu    = optional(string, "100m")<br/>        memory = optional(string, "128Mi")<br/>      }), {})<br/>      limits = optional(object({<br/>        cpu    = optional(string, "100m")<br/>        memory = optional(string, "256Mi")<br/>      }), {})<br/>    }), {})<br/>    loki = optional(object({<br/>      enabled                = optional(bool, false)<br/>      url                    = optional(string, null)<br/>      tenant_id              = optional(string, "default")<br/>      username               = optional(string, "")<br/>      password               = optional(string, "")<br/>      scrape_pods_global     = optional(bool, true)<br/>      scrape_pods_annotation = optional(string, "")<br/>      clustering_enabled     = optional(bool, false)<br/>      scrape_logs_method     = optional(string, "api")<br/>      replicas               = optional(number, 1)<br/>    }), {})<br/>    aws = optional(object({<br/>      account = optional(string, "")<br/>      region  = optional(string, "")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_karpenter"></a> [karpenter](#input\_karpenter) | karperter configuration | <pre>object({<br/>    enabled       = optional(bool, true)<br/>    repository    = optional(string, "public.ecr.aws/karpenter/controller")<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    replicas                   = optional(number, 2)<br/>    tag_key                    = optional(string, "eks:eks-cluster-name")<br/>    enable_disruption          = optional(bool, true)<br/>    batch_max_duration         = optional(string, "10s")<br/>    batch_idle_duration        = optional(string, "1s")<br/>    spot_to_spot_consolidation = optional(bool, false)<br/>    pod_annotations            = optional(map(string), {})<br/>    node_role_arn              = optional(string, null)<br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string, "10")<br/>        memory = optional(string, "300Mi")<br/>      }), {})<br/>      requests = optional(object({<br/>        cpu    = optional(string, "300m")<br/>        memory = optional(string, "256Mi")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_keda"></a> [keda](#input\_keda) | Keda configuration | <pre>object({<br/>    enabled                 = optional(bool, false)<br/>    repository              = optional(string, "https://kedacore.github.io/charts")<br/>    namespace               = optional(string, "cluster-apps")<br/>    replicas                = optional(number, 1)<br/>    webhooks_replicas       = optional(number, 1)<br/>    metrics_server_replicas = optional(number, 1)<br/>    log_level               = optional(string, "info")<br/>    metrics_server          = optional(bool, true)<br/>    node_selector           = optional(map(string), {})<br/>    role_arn                = optional(string, null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), [])<br/>    pod_annotations = optional(map(string), {})<br/>    resources = optional(object({<br/>      operator = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string, "1")<br/>          memory = optional(string, "1000Mi")<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        }), {<br/>        limits   = { cpu = "1", memory = "1000Mi" }<br/>        requests = { cpu = "100m", memory = "100Mi" }<br/>      })<br/>      metricServer = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string, "1")<br/>          memory = optional(string, "1000Mi")<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        }), {<br/>        limits   = { cpu = "1", memory = "1000Mi" }<br/>        requests = { cpu = "100m", memory = "100Mi" }<br/>      })<br/>      webhooks = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string, "1")<br/>          memory = optional(string, "1000Mi")<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        }), {<br/>        limits   = { cpu = "1", memory = "1000Mi" }<br/>        requests = { cpu = "100m", memory = "100Mi" }<br/>      })<br/>      }), {<br/>      operator = {<br/>        limits   = { cpu = "1", memory = "1000Mi" }<br/>        requests = { cpu = "100m", memory = "100Mi" }<br/>      }<br/>      metricServer = {<br/>        limits   = { cpu = "1", memory = "1000Mi" }<br/>        requests = { cpu = "100m", memory = "100Mi" }<br/>      }<br/>      webhooks = {<br/>        limits   = { cpu = "1", memory = "1000Mi" }<br/>        requests = { cpu = "100m", memory = "100Mi" }<br/>      }<br/>    })<br/>    pod_disruption_budget = optional(object({<br/>      operator = optional(object({<br/>        enabled        = optional(bool, false)<br/>        minAvailable   = optional(string, null)<br/>        maxUnavailable = optional(string, "1")<br/>      }), {})<br/>      metricServer = optional(object({<br/>        enabled        = optional(bool, false)<br/>        minAvailable   = optional(string, null)<br/>        maxUnavailable = optional(string, "1")<br/>      }), {})<br/>      webhooks = optional(object({<br/>        enabled        = optional(bool, false)<br/>        minAvailable   = optional(string, null)<br/>        maxUnavailable = optional(string, "1")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_kyverno"></a> [kyverno](#input\_kyverno) | kyverno configuration | <pre>object({<br/>    namespace           = optional(string, "kyverno")<br/>    create_namespace    = optional(bool, true)<br/>    enabled             = optional(bool, false)<br/>    registry            = optional(string, "ghcr.io")<br/>    docker_hub_registry = optional(string, "docker.io")<br/>    node_selector       = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    admission_controller = optional(<br/>      object(<br/>        {<br/>          replicas = optional(number, 2)<br/>          container = optional(object(<br/>            {<br/>              resources = object({<br/>                requests = object({<br/>                  cpu    = optional(string, "300m")<br/>                  memory = optional(string, "384Mi")<br/>                }),<br/>                limits = object({<br/>                  memory = optional(string, "384Mi")<br/>                })<br/>              })<br/>            }<br/>            ),<br/>            {<br/>              resources = {<br/>                requests = {<br/>                  cpu    = "300m"<br/>                  memory = "384Mi"<br/>                }<br/>                limits = {<br/>                  memory = "384Mi"<br/>                }<br/>              }<br/>            }<br/>          )<br/>        }<br/>      ),<br/>      {<br/>        replicas = 2<br/>        container = {<br/>          resources = {<br/>            requests = {<br/>              cpu    = "300m"<br/>              memory = "384Mi"<br/>            }<br/>            limits = {<br/>              memory = "384Mi"<br/>            }<br/>          }<br/>        }<br/>      }<br/>    )<br/>  })</pre> | `{}` | no |
| <a name="input_metrics_server"></a> [metrics\_server](#input\_metrics\_server) | metrics server configuration | <pre>object({<br/>    enabled       = optional(bool, true)<br/>    repository    = optional(string, "registry.k8s.io/metrics-server/metrics-server")<br/>    replicas      = optional(number, 1)<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }), {})<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy cluster apps | <pre>object({<br/>    name   = string<br/>    create = bool<br/>  })</pre> | <pre>{<br/>  "create": true,<br/>  "name": "cluster-apps"<br/>}</pre> | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | node selector to deploy cluster apps | `map(string)` | <pre>{<br/>  "node.kubernetes.io/pool": "critical"<br/>}</pre> | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | tolerations to deploy cluster apps | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "effect": "NoSchedule",<br/>    "key": "CriticalAddonsOnly",<br/>    "operator": "Exists"<br/>  }<br/>]</pre> | no |
| <a name="input_vpa"></a> [vpa](#input\_vpa) | vpa configuration | <pre>object({<br/>    enabled      = optional(bool, false)<br/>    release_name = optional(string, "vpa")<br/>    crds = optional(object({<br/>      enabled = optional(bool, true)<br/>    }), {})<br/>    recommender = optional(object({<br/>      enabled                 = optional(bool, true)<br/>      replica_count           = optional(number, 1)<br/>      service_account_enabled = optional(bool, true)<br/>      resources = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string, "10m")<br/>          memory = optional(string, "70Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    updater = optional(object({<br/>      enabled                 = optional(bool, true)<br/>      replica_count           = optional(number, 1)<br/>      service_account_enabled = optional(bool, true)<br/>      resources = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string, "10m")<br/>          memory = optional(string, "70Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    admissionController = optional(object({<br/>      enabled                 = optional(bool, true)<br/>      replica_count           = optional(number, 1)<br/>      service_account_enabled = optional(bool, true)<br/>      resources = optional(object({<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>        requests = optional(object({<br/>          cpu    = optional(string, "10m")<br/>          memory = optional(string, "50Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->
