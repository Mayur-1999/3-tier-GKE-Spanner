#https://www.terraform.io/language/settings/backends/gcs


terraform {
   backend "gcs" {
   bucket = "sre-statefiles-bucket-0014"
   prefix = "terraform/state"
  }
}
