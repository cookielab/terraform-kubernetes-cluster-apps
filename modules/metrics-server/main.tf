resource "helm_release" "this" {
  name      = "metrics-server"
  namespace = var.namespace

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.13.0"

  values = [yamlencode({
    image = {
      repository = var.repository
    }
    nodeSelector = var.node_selector
    tolerations  = var.tolerations
  })]
}
