# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.18.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create multiple google_compute_instance resources using count
resource "google_compute_instance" "default" {
  count        = var.instance_count
  name         = "gcp-instance-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP
    }
  }
}
