<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.27 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alloy"></a> [alloy](#module\_alloy) | ./modules/alloy | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_external_secrets"></a> [external\_secrets](#module\_external\_secrets) | ./modules/external-secrets | n/a |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ./modules/karpenter | n/a |
| <a name="module_keda"></a> [keda](#module\_keda) | ./modules/keda | n/a |
| <a name="module_kyverno"></a> [kyverno](#module\_kyverno) | ./modules/kyverno | n/a |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | ./modules/metrics-server | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alloy"></a> [alloy](#input\_alloy) | grafana alloy configuration | <pre>object({<br/>    enabled = optional(bool, true)<br/>    loki = optional(<br/>      object({<br/>        url      = string<br/>        username = optional(string, null)<br/>        password = optional(string, null)<br/>      }),<br/>      {<br/>        url      = null<br/>        username = null<br/>        password = null<br/>      }<br/>    )<br/>    loki_scrape_global             = optional(bool, true)<br/>    loki_collect_self_logs_enabled = optional(bool, false)<br/>    prometheus = optional(<br/>      object({<br/>        url      = string<br/>        username = optional(string, null)<br/>        password = optional(string, null)<br/>      }),<br/>      {<br/>        url      = null<br/>        username = null<br/>        password = null<br/>      }<br/>    )<br/>    tenant_id                  = optional(string, "default")<br/>    node_template_file_path    = optional(string, null)<br/>    cluster_template_file_path = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | cert manager configuration | <pre>object({<br/>    enabled       = optional(bool, false)<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of the EKS cluster | `string` | n/a | yes |
| <a name="input_external_secrets"></a> [external\_secrets](#input\_external\_secrets) | external secrets configuration | <pre>object({<br/>    enabled       = optional(bool, true)<br/>    repository    = optional(string, "oci.external-secrets.io/external-secrets/external-secrets")<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>  })</pre> | `{}` | no |
| <a name="input_karpenter"></a> [karpenter](#input\_karpenter) | karperter configuration | <pre>object({<br/>    enabled       = optional(bool, true)<br/>    repository    = optional(string, "public.ecr.aws/karpenter/controller")<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    replicas                   = optional(number, 2)<br/>    tag_key                    = optional(string, "eks:eks-cluster-name")<br/>    enable_disruption          = optional(bool, true)<br/>    batch_max_duration         = optional(string, "10s")<br/>    batch_idle_duration        = optional(string, "1s")<br/>    spot_to_spot_consolidation = optional(bool, false)<br/>    pod_annotations            = optional(map(string), {})<br/>    node_role_arn              = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_keda"></a> [keda](#input\_keda) | Keda configuration | <pre>object({<br/>    enabled        = optional(bool, false)<br/>    repository     = optional(string, "https://kedacore.github.io/charts")<br/>    namespace      = optional(string, "cluster-apps")<br/>    replicas       = optional(number, 2)<br/>    log_level      = optional(string, "info")<br/>    metrics_server = optional(bool, true)<br/>    node_selector  = optional(map(string), {})<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), [])<br/>    pod_annotations = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_kyverno"></a> [kyverno](#input\_kyverno) | kyverno configuration | <pre>object({<br/>    enabled             = optional(bool, false)<br/>    registry            = optional(string, "ghcr.io")<br/>    docker_hub_registry = optional(string, "docker.io")<br/>    node_selector       = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>    admission_controller = optional(<br/>      object(<br/>        {<br/>          replicas = optional(number, 2)<br/>          container = optional(object(<br/>            {<br/>              resources = object({<br/>                requests = object({<br/>                  cpu    = optional(string, "300m")<br/>                  memory = optional(string, "384Mi")<br/>                }),<br/>                limits = object({<br/>                  memory = optional(string, "384Mi")<br/>                })<br/>              })<br/>            }<br/>            ),<br/>            {<br/>              resources = {<br/>                requests = {<br/>                  cpu    = "300m"<br/>                  memory = "384Mi"<br/>                }<br/>                limits = {<br/>                  memory = "384Mi"<br/>                }<br/>              }<br/>            }<br/>          )<br/>        }<br/>      ),<br/>      {<br/>        replicas = 2<br/>        container = {<br/>          resources = {<br/>            requests = {<br/>              cpu    = "300m"<br/>              memory = "384Mi"<br/>            }<br/>            limits = {<br/>              memory = "384Mi"<br/>            }<br/>          }<br/>        }<br/>      }<br/>    )<br/>  })</pre> | `{}` | no |
| <a name="input_metrics_server"></a> [metrics\_server](#input\_metrics\_server) | metrics server configuration | <pre>object({<br/>    enabled       = optional(bool, true)<br/>    repository    = optional(string, "registry.k8s.io/metrics-server/metrics-server")<br/>    node_selector = optional(map(string), null)<br/>    tolerations = optional(list(object({<br/>      key      = string<br/>      operator = string<br/>      value    = optional(string, null)<br/>      effect   = optional(string, null)<br/>    })), null)<br/>  })</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy cluster apps | <pre>object({<br/>    name   = string<br/>    create = bool<br/>  })</pre> | <pre>{<br/>  "create": true,<br/>  "name": "cluster-apps"<br/>}</pre> | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | node selector to deploy cluster apps | `map(string)` | <pre>{<br/>  "node.kubernetes.io/pool": "critical"<br/>}</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"project name"` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | tolerations to deploy cluster apps | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "effect": "NoSchedule",<br/>    "key": "CriticalAddonsOnly",<br/>    "operator": "Exists"<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->