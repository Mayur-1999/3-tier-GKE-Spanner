resource "google_storage_bucket" "statefile-bucket" {
  project                     = var.project_id
  name                        = "test-qwiklabs-gcp-03-02605f581a7f"
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
