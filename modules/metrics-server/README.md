<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy the metrics-server | `string` | `"cluster-apps"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | node selector to deploy the metrics-server | `map(string)` | <pre>{<br/>  "node.kubernetes.io/pool": "critical"<br/>}</pre> | no |
| <a name="input_repository"></a> [repository](#input\_repository) | repository of immage to deploy the metrics-server | `string` | `"registry.k8s.io/metrics-server/metrics-server"` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | tolerations to deploy the metrics-server | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "key": "CriticalAddonsOnly",<br/>    "operator": "Exists"<br/>  }<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->