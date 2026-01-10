# Grafana Alloy Loki Logs Module

This module deploys Grafana Alloy to collect logs from Kubernetes pods and send them to Loki.

## Overview

The module is designed to collect logs from Kubernetes pods and forward them to a Loki instance. Key features include:

- Automatic pod log collection based on annotations
- Global pod log collection option
- Configurable Loki endpoint and authentication
- Support for multi-tenant Loki deployments
- Support for file-based/API-based log collection

The agent runs as a deployment and collects logs from:

- Kubernetes pods marked with the specified annotation (default: loki.logs.enabled)
- All pods in the cluster when global collection is enabled
- Container stdout/stderr streams

## Usage

```hcl
module "loki_logs" {
  source = "./"
  loki = {
    url = "http://loki-gateway.monitoring.svc.cluster.local:80/loki/api/v1/push"
    tenant_id = "default"
  }
  kubernetes_namespace = "monitoring"
  kubernetes_cluster_name = "utils"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |

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
| <a name="input_aws"></a> [aws](#input\_aws) | n/a | <pre>object({<br/>    account = optional(string, "")<br/>    region  = optional(string, "")<br/>  })</pre> | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Alloy | `string` | `"1.0.2"` | no |
| <a name="input_clustering_enabled"></a> [clustering\_enabled](#input\_clustering\_enabled) | Enable clustering for the Grafana Alloy | `bool` | `false` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Alloy River config snippets | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Alloy controller | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "1m")<br/>      memory = optional(string, "5Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, "100m")<br/>      memory = optional(string, "50Mi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_global_tolerations"></a> [global\_tolerations](#input\_global\_tolerations) | Global tolerations for the Grafana Alloy | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    effect   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Alloy | <pre>object({<br/>    registry   = optional(string, "docker.io")<br/>    repository = optional(string, "grafana/alloy")<br/>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_live_debug"></a> [live\_debug](#input\_live\_debug) | Enable live debug for the Grafana Alloy | `bool` | `false` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | Grafana Alloy scrape settings for Loki logs | <pre>object({<br/>    url                    = optional(string, "http://loki:3100")<br/>    tenant_id              = optional(string, "default")<br/>    username               = optional(string, "admin")<br/>    password               = optional(string, "admin")<br/>    scrape_pods_global     = optional(bool, true)<br/>    scrape_pods_annotation = optional(string, "loki.logs.enabled")<br/>    scrape_logs_method     = optional(string, "api")<br/>  })</pre> | `{}` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. | <pre>object({<br/>    endpoint     = optional(string, "http://mimir:9090")<br/>    tenant       = optional(string, "default")<br/>    backend_type = optional(string, "mimir")<br/>  })</pre> | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | Grafana Alloy pod disruption budget configuration | <pre>object({<br/>    enabled         = optional(bool)<br/>    min_available   = optional(number)<br/>    max_unavailable = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "max_unavailable": null,<br/>  "min_available": 1<br/>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Grafana Alloy replicas | `number` | `1` | no |
| <a name="input_stability_level"></a> [stability\_level](#input\_stability\_level) | Stability level for the Grafana Alloy | `string` | `"generally-available"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
