#https://www.terraform.io/language/settings/backends/gcs

terraform {
  backend "gcs" {
    bucket = "statefile-bucket-usc-001"
    prefix = "terraform/test-state"
  }
}
