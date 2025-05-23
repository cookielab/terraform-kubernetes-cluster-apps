<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.27 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.27 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.14 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_irsa"></a> [irsa](#module\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.55.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.disruption_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.disruption_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.iam_pass_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_sqs_queue.disruption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.disruption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [helm_release.crds](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.flow_schema_leader_election](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.flow_schema_workload](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_node_group) | data source |
| [aws_eks_node_groups.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_node_groups) | data source |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.disruption_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iam_pass_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_batch_idle_duration"></a> [batch\_idle\_duration](#input\_batch\_idle\_duration) | the maximum amount of time with no new ending pods that if exceeded ends the current batching window. If pods arrive faster than this time, the batching window will be extended up to the maxDuration. if they arrive slower, the pods will be batched separately. | `string` | `"1s"` | no |
| <a name="input_batch_max_duration"></a> [batch\_max\_duration](#input\_batch\_max\_duration) | the maximum length of a batch window. the longer this is, the more pods we can consider for provisioning at one time which usually results in fewer but larger nodes. | `string` | `"10s"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_disruption"></a> [enable\_disruption](#input\_enable\_disruption) | enable disruption handler | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | value of the namespace to deploy the karpenter | `string` | `"cluster-apps"` | no |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | ARN of IAM role to assume by nodes spinned by karpenter | `string` | `null` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | node selector to deploy the karpenter | `map(string)` | <pre>{<br/>  "node.kubernetes.io/pool": "critical"<br/>}</pre> | no |
| <a name="input_pod_annotations"></a> [pod\_annotations](#input\_pod\_annotations) | annotations to deploy the karpenter | `map(string)` | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | number of replicas to deploy the karpenter | `number` | `2` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | repository of immage to deploy the karpenter | `string` | `"public.ecr.aws/karpenter/controller"` | no |
| <a name="input_spot_to_spot_consolidation"></a> [spot\_to\_spot\_consolidation](#input\_spot\_to\_spot\_consolidation) | setting this to true will enable spot replacement consolidation for both single and multi-node consolidation. | `bool` | `false` | no |
| <a name="input_tag_key"></a> [tag\_key](#input\_tag\_key) | tag key to identify the EKS cluster | `string` | `"eks:eks-cluster-name"` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | tolerations to deploy the karpenter | <pre>list(object({<br/>    key      = string<br/>    operator = string<br/>    value    = optional(string, null)<br/>    effect   = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "effect": "NoSchedule",<br/>    "key": "CriticalAddonsOnly",<br/>    "operator": "Exists"<br/>  }<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->