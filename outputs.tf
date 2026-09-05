# VPC network name

output "vpc_name" {
  description = "Name des VPC-Netzwerks"
  value       = google_compute_network.herzzentrum_vpc.name
}

# Public subnet name

output "public_subnet" {
  description = "Public Subnet"
  value       = google_compute_subnetwork.public_zone.name
}

# Private subnet name

output "private_subnet" {
  description = "Private Subnet"
  value       = google_compute_subnetwork.private_zone.name
}

# Internal IP address of the frontend VM

output "frontend_internal_ip" {
  description = "Interne IP-Adresse der Frontend-VM"
  value       = google_compute_instance.frontend.network_interface[0].network_ip
}

# External IP address of the frontend VM

output "frontend_external_ip" {
  description = "Externe IP-Adresse der Frontend-VM"
  value       = google_compute_instance.frontend.network_interface[0].access_config[0].nat_ip
}
