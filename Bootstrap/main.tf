variable "project_id" {
  type    = string
  default = "value"
}

variable "state_bucket_name" {
  type    = string
  default = "tf-state-bkt-001"
}

resource "google_storage_bucket" "statefile-bucket" {
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = "us-central1"
  force_destroy               = false
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_compute_instance" "vm" {
  name         = "self-hosted-runner"
  project      = var.project_id
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email  = "${var.project_id}@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
