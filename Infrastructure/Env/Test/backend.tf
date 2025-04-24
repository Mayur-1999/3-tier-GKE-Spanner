terraform {
  backend "gcs" {
    bucket = "tf-state-bkt-010"
    prefix = "terraform/test-state"
  }
}
