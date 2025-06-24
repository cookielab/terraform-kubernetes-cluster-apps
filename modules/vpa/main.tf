resource "helm_release" "vpa" {
  name             = var.release_name
  repository       = "https://cowboysysop.github.io/charts"
  chart            = "vertical-pod-autoscaler"
  version          = var.helm_chart_version
  namespace        = var.namespace
  create_namespace = false

  values = [
    yamlencode({
      # Install CRDs
      crds = {
        enabled = var.crds.enabled
      }

      # VPA Recommender
      recommender = {
        enabled      = var.recommender.enabled
        replicaCount = var.recommender.replica_count
        resources = {
          limits = {
            cpu    = var.recommender.resources.limits.cpu
            memory = var.recommender.resources.limits.memory
          }
          requests = {
            cpu    = var.recommender.resources.requests.cpu
            memory = var.recommender.resources.requests.memory
          }
        }
      }

      # VPA Updater
      updater = {
        enabled      = var.updater.enabled
        replicaCount = var.updater.replica_count
        resources = {
          limits = {
            cpu    = var.recommender.resources.limits.cpu
            memory = var.recommender.resources.limits.memory
          }
          requests = {
            cpu    = var.recommender.resources.requests.cpu
            memory = var.recommender.resources.requests.memory
          }
        }
      }

      # VPA Admission Controller
      admissionController = {
        enabled      = var.admissionController.enabled
        replicaCount = var.admissionController.replica_count
        resources = {
          limits = {
            cpu    = var.admissionController.resources.limits.cpu
            memory = var.admissionController.resources.limits.memory
          }
          requests = {
            cpu    = var.admissionController.resources.requests.cpu
            memory = var.admissionController.resources.requests.memory
          }
        }
      }

      # Service accounts
      serviceAccounts = {
        recommender = {
          create = var.recommender.service_account_enabled
        }
        updater = {
          create = var.updater.service_account_enabled
        }
        admissionController = {
          create = var.admissionController.service_account_enabled
        }
      }
    })
  ]

  wait    = true
  timeout = 600
}
