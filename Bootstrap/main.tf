variable "project_id" {
  type    = string
  default = "qwiklabs-gcp-01-d961d1828cf4"
}

variable "state_bucket_name" {
  type    = string
  default = "tf-state-bkt-002"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

resource "google_storage_bucket" "statefile-bucket" {
  count                       = 1
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_compute_instance" "github-runner" {
  count        = 0
  name         = "self-hosted-runner"
  project      = var.project_id
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["self-hosted-runner"]
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250213"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = "projects/${var.project_id}/regions/us-east1/subnetworks/subnet"
    access_config {}
  }

  service_account {
    email  = "${var.project_id}@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "runner-ssh-firewall" {
  count         = 0
  project       = var.project_id
  description   = "firewall to ssh into github runner linux machine"
  name          = "runner-ssh-firewall"
  network       = "vpc"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["self-hosted-runner"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }

  source_tags = ["web"]
}
