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
| <a name="input_admission_controller"></a> [admission\_controller](#input\_admission\_controller) | n/a | <pre>object({<br/>    replicas = optional(number, 2)<br/>    container = optional(object(<br/>      {<br/>        resources = object({<br/>          requests = object({<br/>            cpu    = optional(string, "300m")<br/>            memory = optional(string, "384Mi")<br/>          }),<br/>          limits = object({<br/>            memory = optional(string, "384Mi")<br/>          })<br/>        })<br/>      }<br/>      ),<br/>      {<br/>        resources = {<br/>          requests = {<br/>            cpu    = "300m"<br/>            memory = "384Mi"<br/>          }<br/>          limits = {<br/>            memory = "384Mi"<br/>          }<br/>        }<br/>      }<br/>    )<br/>  })</pre> | <pre>{<br/>  "container": {<br/>    "resources": {<br/>      "limits": {<br/>        "memory": "384Mi"<br/>      },<br/>      "requests": {<br/>        "cpu": "300m",<br/>        "memory": "384Mi"<br/>      }<br/>    }<br/>  },<br/>  "replicas": 2<br/>}</pre> | no |
| <a name="input_docker_hub_registry"></a> [docker\_hub\_registry](#input\_docker\_hub\_registry) | docker hub registry to deploy the kyverno | `string` | `"docker.io"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy the kyverno | `string` | `"cluster-apps"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | node selector to deploy the kyverno | `map(string)` | <pre>{<br/>  "node.kubernetes.io/pool": "critical"<br/>}</pre> | no |
| <a name="input_registry"></a> [registry](#input\_registry) | registry of immage to deploy the kyverno | `string` | `"ghcr.io"` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | tolerations to deploy the kyverno | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "key": "CriticalAddonsOnly",<br/>    "operator": "Exists"<br/>  }<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->