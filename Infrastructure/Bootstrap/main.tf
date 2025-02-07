resource "google_storage_bucket" "gbg-coe-001" {
  project                     = var.project_id           #google_project.main.name
  name                        = var.state_bucket_name
  location                    = var.default_region
  labels                      = var.storage_bucket_labels
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}