#https://www.terraform.io/language/settings/backends/gcs

terraform {
  backend "gcs" {
    bucket = "tf-state-bkt-002"
    prefix = "terraform/dev-state"
  }
}
