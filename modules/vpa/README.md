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
| [helm_release.vpa](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admissionController"></a> [admissionController](#input\_admissionController) | The VPA admission controller configuration | <pre>object({<br/>    enabled                 = optional(bool)<br/>    replica_count           = optional(number)<br/>    service_account_enabled = optional(bool)<br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "replica_count": 1,<br/>  "resources": {<br/>    "limits": {<br/>      "cpu": "200m",<br/>      "memory": "200Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "50m",<br/>      "memory": "50Mi"<br/>    }<br/>  },<br/>  "service_account_enabled": true<br/>}</pre> | no |
| <a name="input_crds"></a> [crds](#input\_crds) | The CRDs to install | <pre>object({<br/>    enabled = optional(bool)<br/>  })</pre> | <pre>{<br/>  "enabled": true<br/>}</pre> | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | The version of the VPA Helm chart to install | `string` | `"10.2.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the VPA in | `string` | `"cluster-apps"` | no |
| <a name="input_recommender"></a> [recommender](#input\_recommender) | The VPA recommender configuration | <pre>object({<br/>    enabled                 = optional(bool)<br/>    replica_count           = optional(number)<br/>    service_account_enabled = optional(bool)<br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "replica_count": 1,<br/>  "resources": {<br/>    "limits": {<br/>      "cpu": "200m",<br/>      "memory": "200Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "50m",<br/>      "memory": "50Mi"<br/>    }<br/>  },<br/>  "service_account_enabled": true<br/>}</pre> | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the Helm release | `string` | `"vpa"` | no |
| <a name="input_updater"></a> [updater](#input\_updater) | The VPA updater configuration | <pre>object({<br/>    enabled                 = optional(bool)<br/>    replica_count           = optional(number)<br/>    service_account_enabled = optional(bool)<br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "replica_count": 1,<br/>  "resources": {<br/>    "limits": {<br/>      "cpu": "200m",<br/>      "memory": "200Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "50m",<br/>      "memory": "50Mi"<br/>    }<br/>  },<br/>  "service_account_enabled": true<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->