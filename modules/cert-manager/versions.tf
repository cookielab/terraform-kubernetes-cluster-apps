terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.27"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}
