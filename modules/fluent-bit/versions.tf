terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }
  }
  required_version = ">= 1.5, < 2.0"
}
