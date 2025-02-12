resource "google_storage_bucket" "backend_bucket" {
  count                       = var.bucket_exist ? 1 : 0
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.default_region
  labels                      = var.storage_bucket_labels
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
