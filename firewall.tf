# Allow HTTP and HTTPS access to the frontend

resource "google_compute_firewall" "allow_web" {
  name    = "allow-web"
  network = google_compute_network.herzzentrum_vpc.name

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["frontend"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}
# Restrict SSH access to Google IAP

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.herzzentrum_vpc.name

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["frontend"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
# Allow PostgreSQL access from the frontend to Cloud SQL
resource "google_compute_firewall" "allow_frontend_to_cloudsql" {
  name      = "allow-frontend-to-cloudsql"
  network   = google_compute_network.herzzentrum_vpc.name
  direction = "EGRESS"
  priority  = 900

  destination_ranges = [
    "${google_sql_database_instance.herzzentrum_db.private_ip_address}/32"
  ]

  target_tags = ["frontend"]

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}

# Deny PostgreSQL access to Cloud SQL from all other VMs
resource "google_compute_firewall" "deny_other_to_cloudsql" {
  name      = "deny-other-to-cloudsql"
  network   = google_compute_network.herzzentrum_vpc.name
  direction = "EGRESS"
  priority  = 1000

  destination_ranges = [
    "${google_sql_database_instance.herzzentrum_db.private_ip_address}/32"
  ]

  deny {
    protocol = "tcp"
    ports    = ["5432"]
  }
}
