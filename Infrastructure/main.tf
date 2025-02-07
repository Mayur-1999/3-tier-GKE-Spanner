provider "google" {
    region = var.region
}

provider "google-beta" {
    region = var.region
}

terraform {
    backend "gcs" {}
}

module "Dev" { 
   count  = var.deployment_env == "dev" ? 1 : 0 
   source = "./Env/Dev"
   region = var.region
   project_id = var.project_id
} 
 
module "prod" { 
   count  = var.deployment_env == "prod" ? 1 : 0 
   source = "./Env/prod"
} 
