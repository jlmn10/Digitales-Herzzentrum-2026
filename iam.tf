# IAM - Service Accounts und Roles

# Service Account for Network-Administration
resource "google_service_account" "network_admin" {
  account_id   = "role-network-admin"
  display_name = "Network Administrator"
}

# Service Account for Reader Databaseaccess
resource "google_service_account" "database_viewer" {
  account_id   = "role-database-viewer"
  display_name = "Database Viewer"
}

# Service Account für Auditing
resource "google_service_account" "auditor" {
  account_id   = "role-auditor"
  display_name = "Auditor"
}

# IAM - Roles and permissions

# Network-Administration
resource "google_project_iam_member" "network_admin_role" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.network_admin.email}"
}

# Cloud SQL - readpermissions
resource "google_project_iam_member" "database_viewer_role" {
  project = var.project_id
  role    = "roles/cloudsql.viewer"
  member  = "serviceAccount:${google_service_account.database_viewer.email}"
}

# Auditor - read Audit and Logs
resource "google_project_iam_member" "auditor_logging_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.auditor.email}"
}

# Auditor - read Security- und IAM-Informations
resource "google_project_iam_member" "auditor_security_reviewer" {
  project = var.project_id
  role    = "roles/iam.securityReviewer"
  member  = "serviceAccount:${google_service_account.auditor.email}"
}
