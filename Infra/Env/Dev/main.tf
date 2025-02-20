module "network" {
  source     = "../../modules/vpc"
  project_id = var.project_id
  vpc_info   = var.vpc_info
}

module "subnetwork" {
  source      = "../../modules/subnet"
  project_id  = var.project_id
  region      = var.region
  network     = module.network.network.self_link
  subnet_info = var.subnet_info
  depends_on = [
    module.network
  ]
}

module "app-firewall" {
  source        = "../../modules/firewall"
  project_id    = var.project_id
  network       = module.network.network.self_link
  firewall_info = var.firewall_info
  allow = [{
    protocol = "TCP"
    ports    = [80, 8080, 443]
  }]
  depends_on = [
    module.network
  ]
}

module "ssh-firewall" {
  source        = "../../modules/firewall"
  project_id    = var.project_id
  network       = module.network.network.self_link
  firewall_info = var.ssh_firewall_info
  allow = [{
    protocol = "TCP"
    ports    = [22]
  }]
  depends_on = [
    module.network
  ]
}

module "nat-gateway" {
  source       = "../../modules/nat-gateway"
  project_id   = var.project_id
  region       = var.region
  network      = module.network.network.self_link
  gateway_name = "nat-gateway"
}




# /******************************************
# 	Firewall
#  *****************************************/

# module "app-fw" {
#   source               = "../../modules/firewall"
#   firewall_description = "Creates firewall rule targeting tagged instances"
#   firewall_name        = "app-fw"
#   network              = module.usc1-vpc.vpc.self_link
#   project_id           = var.project_id
#   target_tags          = []
#   rules_allow = [
#     {
#       protocol = "all"
#       ports    = []
#     }
#   ]
#   source_ranges = ["0.0.0.0/0"]
#   #source_tags   = ["testing", "testing2"]

#   depends_on = [
#     module.usc1-vpc
#   ]
# }


# module "allow-ssh-fw" {
#   source               = "../../modules/firewall"
#   firewall_description = "Creates firewall rule allow ssh"
#   firewall_name        = "allow-ssh-fw"
#   network              = module.usc1-vpc.vpc.self_link
#   project_id           = var.project_id
#   target_tags          = []
#   rules_allow = [
#     {
#       protocol = "tcp"
#       ports    = ["22"]
#     }
#   ]
#   source_ranges = ["0.0.0.0/0"]
#   #source_tags   = ["testing", "testing2"]

#   depends_on = [
#      module.usc1-vpc
#   ]
# }


# module "sre-cluster" {
#   source = "../../modules/GKE"
#   cluster_name = "sre-cluster"
#   project_id =  var.project_id
#   location = var.region
#   node_count = 2
#   initial_node_count = 1
#   tags = ["prometheus"]
#   service_account = var.service_account
#   network =  module.usc1-vpc.vpc.self_link
#   subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/usc1-subnet"

#   depends_on = [ 
#      module.usc1-vpc
#    ] 
# }


/******************************************
	spanner
 *****************************************/

module "spanner" {
  source                  = "../../modules/spanner"
  config                  = "regional-us-central1"
  display_name            = "onlineboutique"
  num_nodes               = 1
  database_name           = "carts"
  db-service_account-id   = "spanner-db-user-sa"
  db-service_account-name = "spanner-db-user-sa"
  # depends_on = [
  #   module.sre-cluster
  # ]
}
