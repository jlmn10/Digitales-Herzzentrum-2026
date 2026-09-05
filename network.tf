# Custom VPC for the Digital Heart Center

resource "google_compute_network" "herzzentrum_vpc" {
  name                    = "herzzentrum-vpc"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.required_apis
  ]
}
# Public subnet for externally reachable services

resource "google_compute_subnetwork" "public_zone" {
  name          = "public-zone"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.herzzentrum_vpc.id
}
# Private subnet for internal services

resource "google_compute_subnetwork" "private_zone" {
  name          = "private-zone"
  ip_cidr_range = "10.10.2.0/24"
  region        = var.region
  network       = google_compute_network.herzzentrum_vpc.id
}
