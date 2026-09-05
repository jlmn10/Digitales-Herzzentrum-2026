# Google Cloud project ID

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

# Deployment region

variable "region" {
  description = "GCP region for the Digital Heart Center"
  type        = string
  default     = "europe-west3"
}

# Deployment zone

variable "zone" {
  description = "GCP zone for Compute Engine resources"
  type        = string
  default     = "europe-west3-a"
}
