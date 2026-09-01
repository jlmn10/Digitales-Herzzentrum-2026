locals {
  required_apis = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iap.googleapis.com"
  ]
}

resource "google_project_service" "required_apis" {
  for_each = toset(local.required_apis)

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}
