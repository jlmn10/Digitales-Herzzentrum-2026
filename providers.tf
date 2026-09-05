# Terraform and Google Cloud provider configuration

terraform {
  required_version = ">= 1.16.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}
# Google Cloud project, region and zone settings

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
