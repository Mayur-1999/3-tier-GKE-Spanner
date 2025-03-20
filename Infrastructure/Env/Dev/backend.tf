#https://www.terraform.io/language/settings/backends/gcs

terraform {
  backend "gcs" {
    bucket = "tf-state-bkt-005"
    prefix = "terraform/dev-state"
  }
}
