<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.27 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.4 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.cert_manager_crds](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [http_http.cert_manager_crd](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy the cert manager | `string` | `"cluster-apps"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | node selector to deploy the cert manager | `map(string)` | <pre>{<br/>  "node.kubernetes.io/pool": "critical"<br/>}</pre> | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | tolerations to deploy the cert manager | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->