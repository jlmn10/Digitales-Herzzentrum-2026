terraform {
backend "gcs" {
bucket = "digitales-herzzentrum-2026-tfstate"
prefix = "terraform/state"
}
}
