# Grafana Alloy Cluster Module

This module deploys Grafana Alloy to collect metrics from a Kubernetes cluster.

## Overview

The module is designed to collect various metrics from a Kubernetes cluster including:

- Kubernetes pod metrics
- cAdvisor container metrics  
- Kubelet metrics
- Service metrics

The agent runs as a deployment and collects metrics from:

- Kubernetes API server for pod and service metrics
- Kubelet API for node and container metrics 
- cAdvisor for detailed container metrics

The module supports scaling to multiple replicas for high availability and load distribution when collecting metrics.

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
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Alloy | `string` | `"1.0.2"` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Alloy River config snippets | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Alloy controller | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "1m")<br/>      memory = optional(string, "5Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, "100m")<br/>      memory = optional(string, "50Mi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_global_tolerations"></a> [global\_tolerations](#input\_global\_tolerations) | Global tolerations for the Grafana Alloy | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    effect   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Alloy | <pre>object({<br/>    registry   = optional(string, "docker.io")<br/>    repository = optional(string, "grafana/alloy")<br/>  })</pre> | `{}` | no |
| <a name="input_k8s_cadvisor"></a> [k8s\_cadvisor](#input\_k8s\_cadvisor) | Grafana Alloy scrape timings for K8S cadvisor | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>  })</pre> | `{}` | no |
| <a name="input_k8s_kubelet"></a> [k8s\_kubelet](#input\_k8s\_kubelet) | Grafana Alloy scrape timings for K8S kubelet | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>  })</pre> | `{}` | no |
| <a name="input_k8s_pods"></a> [k8s\_pods](#input\_k8s\_pods) | Grafana Alloy scrape timings for K8S pods | <pre>object({<br/>    scrape_interval        = optional(string, "1m")<br/>    scrape_timeout         = optional(string, "30s")<br/>    scrape_pods_global     = optional(bool, false)<br/>    scrape_pods_annotation = optional(string, "prometheus_io_scrape")<br/>  })</pre> | `{}` | no |
| <a name="input_k8s_services"></a> [k8s\_services](#input\_k8s\_services) | Grafana Alloy scrape timings for K8S services | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. | <pre>object({<br/>    endpoint     = optional(string, "http://mimir:9090")<br/>    tenant       = optional(string, "default")<br/>    backend_type = optional(string, "mimir")<br/>    ssl_enabled  = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | Grafana Alloy pod disruption budget configuration | <pre>object({<br/>    enabled         = optional(bool)<br/>    min_available   = optional(number)<br/>    max_unavailable = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "max_unavailable": null,<br/>  "min_available": 1<br/>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Grafana Alloy replicas | `number` | `1` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
