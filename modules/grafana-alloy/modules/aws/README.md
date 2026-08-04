# Grafana Alloy AWS Module

This module deploys Grafana Alloy to collect metrics from AWS services via CloudWatch.

## Overview

The module is designed to collect various metrics from AWS services including:

- Amazon RDS metrics
- Amazon OpenSearch metrics  
- Amazon SQS metrics
- Other CloudWatch metrics

The agent runs as a deployment and collects metrics from:

- AWS CloudWatch API to gather service metrics
- Supports collecting metrics from multiple AWS regions
- Allows filtering and aggregation of metrics before sending

The module supports scaling to multiple replicas for high availability and load distribution when collecting metrics.

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
| <a name="input_autoscaling"></a> [autoscaling](#input\_autoscaling) | Autoscaling (HPA) configuration. Active when clustering\_enabled = true. | <pre>object({<br/>    min_replicas                      = optional(number, 2)<br/>    max_replicas                      = optional(number, 5)<br/>    target_cpu_utilization_percentage = optional(number, 80)<br/>  })</pre> | `{}` | no |
| <a name="input_aws_alb"></a> [aws\_alb](#input\_aws\_alb) | Grafana Alloy scrape aws ALB metrics | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>    scrape_period   = optional(string, "1m")<br/>    region          = optional(string, "eu-west-1")<br/>    search_tags     = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_aws_mq"></a> [aws\_mq](#input\_aws\_mq) | Grafana Alloy scrape aws MQ metrics | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>    scrape_period   = optional(string, "1m")<br/>    region          = optional(string, "eu-west-1")<br/>    search_tags     = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_aws_opensearch"></a> [aws\_opensearch](#input\_aws\_opensearch) | Grafana Alloy scrape aws opensearch cloudwatch metrics | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>    scrape_period   = optional(string, "1m")<br/>    region          = optional(string, "eu-west-1")<br/>  })</pre> | `{}` | no |
| <a name="input_aws_rds"></a> [aws\_rds](#input\_aws\_rds) | Grafana Alloy scrape aws RDS metrics | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>    scrape_period   = optional(string, "1m")<br/>    region          = optional(string, "eu-west-1")<br/>    search_tags     = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_aws_sqs"></a> [aws\_sqs](#input\_aws\_sqs) | Grafana Alloy scrape aws SQS metrics | <pre>object({<br/>    scrape_interval = optional(string, "1m")<br/>    scrape_timeout  = optional(string, "30s")<br/>    scrape_period   = optional(string, "1m")<br/>    region          = optional(string, "eu-west-1")<br/>    search_tags     = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Alloy | `string` | `"1.0.2"` | no |
| <a name="input_clustering_enabled"></a> [clustering\_enabled](#input\_clustering\_enabled) | Enable Grafana Alloy clustering. | `bool` | `false` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Alloy River config snippets | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Alloy controller | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "1m")<br/>      memory = optional(string, "5Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, "100m")<br/>      memory = optional(string, "50Mi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_tolerations"></a> [global\_tolerations](#input\_global\_tolerations) | Global tolerations for the Grafana Alloy | <pre>list(object({<br/>    key               = string<br/>    operator          = string<br/>    value             = optional(string)<br/>    effect            = string<br/>    tolerationSeconds = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_host_network"></a> [host\_network](#input\_host\_network) | Enable hostNetwork for the Grafana Alloy controller. When null, defaults to true for daemonset and false for deployment. | `bool` | `null` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | This role is for assuming by cloudwatch exporter | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Alloy | <pre>object({<br/>    registry   = optional(string, "docker.io")<br/>    repository = optional(string, "grafana/alloy")<br/>  })</pre> | `{}` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress configuration for Grafana Alloy. | <pre>object({<br/>    enabled            = optional(bool, false)<br/>    ingress_class_name = optional(string, null)<br/>    annotations        = optional(map(string), {})<br/>    labels             = optional(map(string), {})<br/>    path               = optional(string, "/")<br/>    path_type          = optional(string, "Prefix")<br/>    hosts              = optional(list(string), [])<br/>    extra_paths        = optional(list(any), [])<br/>    tls = optional(list(object({<br/>      secret_name = optional(string)<br/>      hosts       = optional(list(string), [])<br/>    })), [])<br/>    port = optional(number, 12345)<br/>  })</pre> | `{}` | no |
| <a name="input_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_kind"></a> [kubernetes\_kind](#input\_kubernetes\_kind) | Grafana Alloy Kubernetes resource kind. Valid values are "deployment" or "daemonset". | `string` | `"deployment"` | no |
| <a name="input_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. Mimir and Promethes backends are supported. | <pre>object({<br/>    endpoint     = optional(string, "http://mimir:9090")<br/>    tenant       = optional(string, "default")<br/>    backend_type = optional(string, "mimir")<br/>    ssl_enabled  = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | Grafana Alloy pod disruption budget configuration | <pre>object({<br/>    enabled         = optional(bool)<br/>    min_available   = optional(number)<br/>    max_unavailable = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "max_unavailable": null,<br/>  "min_available": 1<br/>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Grafana Alloy replicas. | `number` | `1` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
