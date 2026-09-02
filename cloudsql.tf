# Cloud SQL plazieren: Private Database

#Private IP- Domain for Cloud SQL
ressource "google_compute_global_address" "cloudsql_private_range" {
  name          = "cloudsql-private-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16"
  network = google_compute_network.herzzentrum_vpc.id
}

# Private Services Access
resource "google_service_networking_connection" "cloudsql_private_connection" {
  network = google_compute_network.herzzentrum_vpc.id
  service = "servicenetworking.googleapis.com"

  reserved_peering_ranges = [
    google_compute_global_address.cloudsql_private_range.name
  ]
}

# Cloud SQL PostgreSQL
resource "google_sql_database_instance" "herzzentrum_db" {
  name             = "herzzentrum-db"
  database_version = "POSTGRES_15"
  region           = "europe-west3"

  depends_on = [
    google_service_networking_connection.cloudsql_private_connection
  ]

settings {
    tier = "db-f1-micro"

    ip_configuration {
      #No public IP-address
      ipv4_enabled = false

      # Cloud SQL via its own VPC
      private_network = google_compute_network.herzzentrum_vpc.id
    }

    # Automatic Backups
    backup_configuration {
      enabled = true

      # Point-in-Time-Recovery
      point_in_time_recovery_enabled = true
    }
  }
}
# Database
resource "google_sql_database" "herzzentrum_database" {
  name     = "heartcenter"
  instance = google_sql_database_instance.herzzentrum_db.name
}

