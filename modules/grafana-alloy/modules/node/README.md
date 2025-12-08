# Grafana Alloy Node Exporter Module

This module deploys Grafana Alloy as a DaemonSet to collect node metrics from a Kubernetes cluster using node_exporter.

## Overview

The module runs Grafana Alloy with node_exporter integration on each Kubernetes node to collect system-level metrics like:

- CPU usage
- Memory usage 
- Disk I/O
- Network statistics
- System load
- And other node-level metrics

The agent runs in privileged mode with access to host filesystem mounts to gather complete node metrics.
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
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Alloy | <pre>object({<br/>    registry   = optional(string, "docker.io")<br/>    repository = optional(string, "grafana/alloy")<br/>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. Mimir and Promethes backends are supported. | <pre>object({<br/>    endpoint     = optional(string, "http://mimir:9090")<br/>    tenant       = optional(string, "default")<br/>    backend_type = optional(string, "mimir")<br/>    ssl_enabled  = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_node_exporter"></a> [node\_exporter](#input\_node\_exporter) | Grafana Alloy scrape timings for K8S node\_exporter | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>  })</pre> | `{}` | no |
| <a name="input_otel"></a> [otel](#input\_otel) | Grafana Alloy OTel configuration. NOTE: There can be only one OTel receiver at the moment. | <pre>object({<br/>    enabled   = optional(bool, false)<br/>    http_port = optional(number, 4318)<br/>    grpc_port = optional(number, 4317)<br/>    endpoint  = optional(string, "http://tempo:4318")<br/>  })</pre> | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | Grafana Alloy pod disruption budget configuration | <pre>object({<br/>    enabled         = optional(bool)<br/>    min_available   = optional(number)<br/>    max_unavailable = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "max_unavailable": null,<br/>  "min_available": 1<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otel_endpoints"></a> [otel\_endpoints](#output\_otel\_endpoints) | Exposed OTel endpoints |
<!-- END_TF_DOCS -->
