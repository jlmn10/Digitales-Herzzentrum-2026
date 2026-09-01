resource "google_compute_network" "herzzentrum_vpc" {
  name                    = "herzzentrum-vpc"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_compute_subnetwork" "public_zone" {
  name          = "public-zone"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.herzzentrum_vpc.id
}

resource "google_compute_subnetwork" "private_zone" {
  name          = "private-zone"
  ip_cidr_range = "10.10.2.0/24"
  region        = var.region
  network       = google_compute_network.herzzentrum_vpc.id
}
