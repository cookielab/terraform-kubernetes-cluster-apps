<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.27 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.27 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.14 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cluster](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.node](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_template_file_path"></a> [cluster\_template\_file\_path](#input\_cluster\_template\_file\_path) | path to cluster template file | `string` | `null` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | configuration for loki | <pre>object({<br/>    url      = string<br/>    username = optional(string, null)<br/>    password = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_loki_collect_self_logs_enabled"></a> [loki\_collect\_self\_logs\_enabled](#input\_loki\_collect\_self\_logs\_enabled) | collect logs from alloy | `bool` | `false` | no |
| <a name="input_loki_scrape_global"></a> [loki\_scrape\_global](#input\_loki\_scrape\_global) | loki scrape global | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy the external-secrets | `string` | `"cluster-apps"` | no |
| <a name="input_node_template_file_path"></a> [node\_template\_file\_path](#input\_node\_template\_file\_path) | path to node template file | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |
| <a name="input_prometheus"></a> [prometheus](#input\_prometheus) | configuration for prometheus | <pre>object({<br/>    url      = string<br/>    username = optional(string, null)<br/>    password = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | tenant id | `string` | `"default"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->