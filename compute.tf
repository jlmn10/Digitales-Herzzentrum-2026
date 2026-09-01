resource "google_compute_instance" "frontend" {
  name         = "frontend-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["frontend"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_zone.id

    access_config {
    }
  }
}
