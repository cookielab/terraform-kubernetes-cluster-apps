<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Logging level for Keda operator | `string` | `"info"` | no |
| <a name="input_metrics_server"></a> [metrics\_server](#input\_metrics\_server) | Enable Keda's Prometheus metrics adapter | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where Keda will be deployed | `string` | `"cluster-apps"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node selector for Keda pods | `map(string)` | `{}` | no |
| <a name="input_pod_annotations"></a> [pod\_annotations](#input\_pod\_annotations) | Annotations for Keda pods | `map(string)` | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas for Keda operator | `number` | `2` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Helm repository URL for Keda | `string` | `"https://kedacore.github.io/charts"` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM Role for Keda ServiceAccount | `string` | n/a | yes |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations for Keda pods | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->