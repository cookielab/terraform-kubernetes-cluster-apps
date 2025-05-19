# Fluent Bit for sending logs

This module contains the configuration for deploying Fluent Bit with sending logs to various destinations. Predefined are `Loki` or `Elasticsearch`, but you can also define your own outputs.

## Variables

### Common Variables

- `namespace` - The namespace to deploy the fluent-bit service to
- `logs_storage` - The type of logs storage to use (elasticsearch or loki)
- `logs_endpoint_url` - The URL of the logs endpoint
- `logs_labels` - The labels for the logs
- `logs_custom` - The custom configurations for logs, including outputs, filters, and inputs
- `use_defaults` - Whether to use the default outputs, filters and inputs

### Elasticsearch Variables

- `elasticsearch` - The Elasticsearch configuration
  - `auth` - The authentication configuration for Elasticsearch
    - `enabled` - Enable/disable authentication (default: false)
    - `username` - Username for authentication
    - `password` - Password for authentication

### Loki Variables

- `loki` - The Loki configuration
  - `basic_auth` - The basic authentication configuration for Loki
    - `enabled` - Enable/disable basic auth (default: false)
    - `username` - Username for basic auth
    - `password` - Password for basic auth
  - `bearer_token` - The bearer token authentication configuration for Loki
    - `enabled` - Enable/disable bearer token auth (default: false)
    - `token` - The bearer token value
  - `tenant_id` - The Loki tenant ID (default: "default")

## Usage

```hcl
module "fluent-bit" {
  source            = "./modules/fluent-bit"
  namespace         = "monitoring"
  logs_storage      = "elasticsearch"
  logs_endpoint_url = "elasticsearch.xxx.svc.cluster.local"
  logs_custom = {
    outputs = {
      "output1" = <<EOF
Name output1
Match xxx*
EOF
    }
    inputs = {
      "input1" = <<EOF
Name input1
Match xxx*
EOF
    }
    filters = {
      "filter1" = <<EOF
Name filter1
Match xxx*
EOF
    }
  }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.fluentbit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elasticsearch"></a> [elasticsearch](#input\_elasticsearch) | n/a | <pre>object({<br/>    auth = optional(object({<br/>      enabled  = optional(bool, false)<br/>      username = optional(string)<br/>      password = optional(string)<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_logs_custom"></a> [logs\_custom](#input\_logs\_custom) | The custom configurations for logs, including outputs, filters, and inputs | <pre>object({<br/>    outputs = optional(map(string), {})<br/>    filters = optional(map(string), {})<br/>    inputs  = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "filters": {},<br/>  "inputs": {},<br/>  "outputs": {}<br/>}</pre> | no |
| <a name="input_logs_endpoint_url"></a> [logs\_endpoint\_url](#input\_logs\_endpoint\_url) | The URL of the logs endpoint | `string` | n/a | yes |
| <a name="input_logs_labels"></a> [logs\_labels](#input\_logs\_labels) | The labels for the logs | `map(string)` | `{}` | no |
| <a name="input_logs_storage"></a> [logs\_storage](#input\_logs\_storage) | The type of logs storage to use | `string` | `"loki"` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | n/a | <pre>object({<br/>    basic_auth = optional(object({<br/>      enabled  = optional(bool, false)<br/>      username = optional(string)<br/>      password = optional(string)<br/>    }), {})<br/>    bearer_token = optional(object({<br/>      enabled = optional(bool, false)<br/>      token   = optional(string)<br/>    }), {})<br/>    tenant_id = optional(string, "default")<br/>  })</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the Fluent Bit service to | `string` | `"monitoring"` | no |
| <a name="input_use_defaults"></a> [use\_defaults](#input\_use\_defaults) | Whether to use the default outputs | `map(bool)` | <pre>{<br/>  "filters": true,<br/>  "inputs": true,<br/>  "outputs": true<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
