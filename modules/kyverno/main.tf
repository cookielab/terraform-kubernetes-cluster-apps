resource "helm_release" "this" {
  name      = "kyverno"
  namespace = var.namespace

  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  version    = "3.5.0"

  values = [yamlencode({
    # https://github.com/kyverno/kyverno/pull/11482/checks?check_run_id=32231441646
    global = {
      image = {
        registry = var.registry
      }
      nodeSelector = var.node_selector
      tolerations  = var.tolerations
    }
    webhooksCleanup = {
      image = {
        registry = var.docker_hub_registry
      }
    }
    policyReportsCleanup = {
      image = {
        registry = var.docker_hub_registry
      }
    }
    admissionController = var.admission_controller
  })]
}

resource "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}
