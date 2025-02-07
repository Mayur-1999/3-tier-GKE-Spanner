provider "google" {
    region = var.region
}

provider "google-beta" {
    region = var.region
}

terraform {
    backend "gcs" {}
}

//calling out the module from dev folder 
module "Dev" { 
   count  = var.deployment_env == "dev" ? 1 : 0 
   source = "./Env/Dev"
   region = var.region
} 
 
# module "prod" { 
#    count  = var.deployment_env == "prod" ? 1 : 0 
#    source = "./Env/prod"
#    region = var.region
# } 
