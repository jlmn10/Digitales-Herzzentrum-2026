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
