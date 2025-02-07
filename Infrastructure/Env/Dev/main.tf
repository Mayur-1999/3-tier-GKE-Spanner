
/******************************************
	VPC configuration
 *****************************************/


#Trust Vpc

module "usc1-trust-vpc-001" {
  source                  = "./modules/vpc"
  project_id              = var.project_id
  network_name            = "usc1-trust-vpc-001"
  auto_create_subnetworks = false
}

module "usc1-trustsubnet-001" {
  source       = "./modules/subnet"
  project_id   = var.project_id
  network_name = module.usc1-trust-vpc-001.vpc.self_link

  subnets = [{
    subnet_name           = "usc1-trustsubnet-001"
    subnet_region         = "us-central1"
    subnet_ip             = "10.10.0.0/24"
    subnet_flow_logs      = "false"
    subnet_private_access = "true"
    }
  ]
  depends_on = [
    module.usc1-trust-vpc-001
  ]
}

/******************************************
	Firewall
 *****************************************/

module "gbg-app-fw-001" {
  source               = "./modules/firewall"
  firewall_description = "Creates firewall rule targeting tagged instances"
  firewall_name        = "gbg-app-fw-001"
  network              = module.usc1-trust-vpc-001.vpc.self_link
  project_id           = var.project_id
  target_tags          = []
  rules_allow = [
    {
      protocol = "all"
      ports    = []
    }
  ]
  source_ranges = ["0.0.0.0/0"]
  #source_tags   = ["testing", "testing2"]

  depends_on = [
    module.usc1-trust-vpc-001
  ]
}


module "allow-ssh-fw-001" {
  source               = "./modules/firewall"
  firewall_description = "Creates firewall rule allow ssh"
  firewall_name        = "allow-ssh-fw-001"
  network              = module.usc1-trust-vpc-001.vpc.self_link
  project_id           = var.project_id
  target_tags          = []
  rules_allow = [
    {
      protocol = "tcp"
      ports    = ["22"]
    }
  ]
  source_ranges = ["0.0.0.0/0"]
  #source_tags   = ["testing", "testing2"]

  depends_on = [
     module.usc1-trust-vpc-001
  ]
}


/******************************************
	GKE
 *****************************************/


module "sre-cluster" {
  source = "./modules/gke"
  cluster_name = "sre-cluster"
  project_id =  var.project_id
  location = var.region
  node_count = 2
  initial_node_count = 1
  tags = ["prometheus"]
  service_account = var.service_account
  network =  module.usc1-trust-vpc-001.vpc.self_link
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/usc1-trustsubnet-001"

  depends_on = [ 
     module.usc1-trust-vpc-001
   ] 
}


/******************************************
	spanner
 *****************************************/

 module "spanner" {
   source = "./modules/spanner"
   config = "regional-us-central1"
   display_name = "onlineboutique"
   num_nodes = 1
   database_name = "carts"
   db-service_account-id =  "spanner-db-user-sa"
   db-service_account-name = "spanner-db-user-sa"
   depends_on = [ 
     module.sre-cluster
   ] 
 }




