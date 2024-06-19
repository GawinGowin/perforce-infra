data "google_client_config" "default" {}
data "google_project" "project" {}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.30.0"
    }
  }
}

provider "google" {
  project = "vivid-willow-381410"
  default_labels = {
    tool = "terraform"
    created_by = "saraki"
  }
}

variable "instance_name" {
  default = "perforce-server"
  type = string
}

variable "container_config_path" {
  type = string
  default = "container_config.yaml"
}

output "project" {
  value = data.google_client_config.default.project
}

output "project_number" {
  value = data.google_project.project.number
}

output "ipaddress" {
  value = google_compute_address.perforce_ip.address
}