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