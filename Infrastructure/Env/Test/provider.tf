# https://registry.terraform.io/providers/hashicorp/google/latest/docs

provider "google" {
  
  project = var.project_id
  region  = var.region

}

provider "google-beta" {
    region = var.region
}




