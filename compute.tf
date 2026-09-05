# Small frontend VM in the public zone

resource "google_compute_instance" "frontend" {
  name = "frontend-vm"

  # Cost-efficient machine type for the prototype
  machine_type = "e2-micro"

  zone = var.zone

  # Network tag used by the firewall rules
  tags = ["frontend"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  # Connect the frontend to the public subnet
  network_interface {
    subnetwork = google_compute_subnetwork.public_zone.id

    access_config {
    }
  }
}
