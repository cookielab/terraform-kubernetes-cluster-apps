resource "kubernetes_manifest" "flow_schema_leader_election" {
  manifest = {
    apiVersion = "flowcontrol.apiserver.k8s.io/v1"
    kind       = "FlowSchema"

    metadata = {
      name = "karpenter-leader-election"
    }

    spec = {
      distinguisherMethod = {
        type = "ByUser"
      }
      matchingPrecedence = 200
      priorityLevelConfiguration = {
        name = "leader-election"
      }
      rules = [
        {
          resourceRules = [
            {
              apiGroups = [
                "coordination.k8s.io"
              ]
              namespaces = ["*"]
              resources = [
                "leases"
              ]
              verbs = [
                "get",
                "create",
                "update"
              ]
            }
          ]
          subjects = [
            {
              kind = "ServiceAccount"
              serviceAccount = {
                namespace = var.namespace
                name      = local.karpenter_service_account_name
              }
            }
          ]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "flow_schema_workload" {
  manifest = {
    apiVersion = "flowcontrol.apiserver.k8s.io/v1"
    kind       = "FlowSchema"

    metadata = {
      name = "karpenter-workload"
    }

    spec = {
      distinguisherMethod = {
        type = "ByUser"
      }
      matchingPrecedence = 1000
      priorityLevelConfiguration = {
        name = "workload-high"
      }
      rules = [
        {
          nonResourceRules = [
            {
              nonResourceURLs = ["*"]
              verbs           = ["*"]
            }
          ]
          resourceRules = [
            {
              apiGroups    = ["*"]
              clusterScope = true
              namespaces   = ["*"]
              resources    = ["*"]
              verbs        = ["*"]
            }
          ]
          subjects = [
            {
              kind = "ServiceAccount"
              serviceAccount = {
                namespace = var.namespace
                name      = local.karpenter_service_account_name
              }
            }
          ]
        }
      ]
    }
  }
}
