#https://www.terraform.io/language/settings/backends/gcs

terraform {
  backend "gcs" {
    bucket = "tf-state-bkt-007"
    prefix = "terraform/dev-state"
  }
}
