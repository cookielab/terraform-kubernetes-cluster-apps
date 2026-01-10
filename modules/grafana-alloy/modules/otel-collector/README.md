# Grafana Alloy OpenTelemetry Collector

This module deploys a Grafana Alloy configured as an OpenTelemetry collector to receive and process telemetry data. It can ingest traces and metrics via OTLP protocol and forward them to Grafana Tempo and Mimir backends.

## Usage

```
module "otel_collector" {
  source  = "..."
  version = "..."

  mimir_http_host = "mimir.example.com"

  tempo_http_host = "tempo.example.com"

  kubernetes_cluster_name = "somecluster"
  kubernetes_namespace    = "cluster-apps"
}
```

## Kubernetes usage resources

```
  resources = {
    requests = {
      cpu    = "100m"
      memory = "100Mi"
    }
    limits = {
      cpu    = "1"
      memory = "1Gi"
    }
  }
```

Please note, when limits are undefined, requests values are used for limits too.

------------------------------------

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.grafana_otel_collector](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the Grafana OTel agent | `string` | `"otel"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Alloy 	.0.2"` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_kind"></a> [kubernetes\_kind](#input\_kubernetes\_kind) | Grafana Alloy Kubernetes resource kind | `string` | `"deployment"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_listen_port_grpc"></a> [listen\_port\_grpc](#input\_listen\_port\_grpc) | gRPC port of the OTel listener | `number` | `4317` | no |
| <a name="input_listen_port_http"></a> [listen\_port\_http](#input\_listen\_port\_http) | HTTP port of the OTel listener | `number` | `4318` | no |
| <a name="input_mimir_http_host"></a> [mimir\_http\_host](#input\_mimir\_http\_host) | Mimir endpoint host | `string` | n/a | yes |
| <a name="input_mimir_http_port"></a> [mimir\_http\_port](#input\_mimir\_http\_port) | Mimir endpoint port | `number` | `443` | no |
| <a name="input_mimir_http_scheme"></a> [mimir\_http\_scheme](#input\_mimir\_http\_scheme) | Mimir endpoint HTTP scheme | `string` | `"https"` | no |
| <a name="input_mimir_http_uripath"></a> [mimir\_http\_uripath](#input\_mimir\_http\_uripath) | Mimir endpoint URI path | `string` | `"/api/v1/push"` | no |
| <a name="input_mimir_tenant"></a> [mimir\_tenant](#input\_mimir\_tenant) | Mimir Tenant name | `string` | `"default"` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Grafana Alloy operation mode | `string` | `"flow"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resources for the Grafana OTel agent | <pre>object({<br>    requests = optional(object({<br>      cpu    = optional(string, "500m")<br>      memory = optional(string, "512Mi")<br>    }), {})<br>    limits = optional(object({<br>      cpu    = optional(string, null)<br>      memory = optional(string, null)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_tempo_http_host"></a> [tempo\_http\_host](#input\_tempo\_http\_host) | Tempo OTel endpoint host | `string` | n/a | yes |
| <a name="input_tempo_http_port"></a> [tempo\_http\_port](#input\_tempo\_http\_port) | Tempo OTel endpoint port | `number` | `443` | no |
| <a name="input_tempo_http_scheme"></a> [tempo\_http\_scheme](#input\_tempo\_http\_scheme) | Tempo OTel endpoint HTTP scheme | `string` | `"https"` | no |
| <a name="input_tempo_http_uripath"></a> [tempo\_http\_uripath](#input\_tempo\_http\_uripath) | Tempo OTel endpoint URI path | `string` | `"/v1/traces"` | no |
| <a name="input_stability_level"></a> [stability\_level](#input\_stability\_level) | Stability level for grafana alloy. Needs to be 'experimental' for debug traces etc... | `string` | `"generally-available"` | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otel_grpc_endpoint"></a> [otel\_grpc\_endpoint](#output\_otel\_grpc\_endpoint) | Exposed OTel traces gRPC endpoint |
| <a name="output_otel_http_endpoint"></a> [otel\_http\_endpoint](#output\_otel\_http\_endpoint) | Exposed OTel traces HTTP endpoint |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana_alloy"></a> [grafana\_alloy](#module\_grafana\_alloy) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_resources"></a> [agent\_resources](#input\_agent\_resources) | Resources for the Grafana OTel agent | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "500m")<br/>      memory = optional(string, "512Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, null)<br/>      memory = optional(string, null)<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Alloy | `string` | `"1.0.2"` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Alloy River config snippets | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Alloy controller | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "1m")<br/>      memory = optional(string, "5Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, "100m")<br/>      memory = optional(string, "50Mi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_global_tolerations"></a> [global\_tolerations](#input\_global\_tolerations) | Global tolerations for the Grafana Alloy | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    effect   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | This role is for assuming by cloudwatch exporter | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Alloy | <pre>object({<br/>    registry   = optional(string, "docker.io")<br/>    repository = optional(string, "grafana/alloy")<br/>  })</pre> | `{}` | no |
| <a name="input_kafka_jmx_metrics"></a> [kafka\_jmx\_metrics](#input\_kafka\_jmx\_metrics) | Grafana Alloy scrape JMX kafka metrics | <pre>object({<br/>    scrape_interval       = optional(string, "1m")<br/>    scrape_timeout        = optional(string, "30s")<br/>    scrape_period         = optional(string, "1m")<br/>    kafka_broker_list     = optional(list(string), [])<br/>    distinguisher         = optional(string, "default")<br/>    metrics_endpoint_path = optional(string, "/metrics")<br/>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. Mimir and Promethes backends are supported. | <pre>object({<br/>    endpoint     = optional(string, "http://mimir:9090")<br/>    tenant       = optional(string, "default")<br/>    backend_type = optional(string, "mimir")<br/>    ssl_enabled  = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_otel"></a> [otel](#input\_otel) | Grafana Alloy OTel settings | <pre>object({<br/>    endpoint                  = optional(string, "http://tempo:9090")<br/>    service_graphs_dimensions = optional(list(string), [])<br/>    http_port                 = optional(number, 4318)<br/>    grpc_port                 = optional(number, 4317)<br/>  })</pre> | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | Grafana Alloy pod disruption budget configuration | <pre>object({<br/>    enabled         = optional(bool)<br/>    min_available   = optional(number)<br/>    max_unavailable = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "max_unavailable": null,<br/>  "min_available": 1<br/>}</pre> | no |
| <a name="input_stability_level"></a> [stability\_level](#input\_stability\_level) | Stability level for grafana alloy. Needs to be 'experimental' for debug traces etc... | `string` | `"generally-available"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->