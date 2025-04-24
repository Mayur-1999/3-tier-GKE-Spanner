#https://www.terraform.io/language/settings/backends/gcs

terraform {
  backend "gcs" {
    bucket = "tf-state-bkt-010"
    prefix = "terraform/dev-state"
  }
}
