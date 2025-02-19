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
