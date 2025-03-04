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

# module "app-firewall" {
#   source        = "../../modules/firewall"
#   project_id    = var.project_id
#   network       = module.network.network.self_link
#   firewall_info = var.firewall_info
#   allow = [{
#     protocol = "TCP"
#     ports    = [80, 8080, 443]
#   }]
#   depends_on = [
#     module.network
#   ]
# }

# module "ssh-firewall" {
#   source        = "../../modules/firewall"
#   project_id    = var.project_id
#   network       = module.network.network.self_link
#   firewall_info = var.ssh_firewall_info
#   allow = [{
#     protocol = "TCP"
#     ports    = [22]
#   }]
#   depends_on = [
#     module.network
#   ]
# }

# module "nat-gateway" {
#   source       = "../../modules/nat-gateway"
#   project_id   = var.project_id
#   region       = var.region
#   network      = module.network.network.self_link
#   gateway_name = "nat-gateway"
# }

# module "spanner" {
#   source                  = "../../modules/spanner"
#   config                  = "regional-us-central1"
#   display_name            = "onlineboutique"
#   project_id              = var.project_id
#   num_nodes               = 1
#   database_name           = "carts"
#   db-service_account-id   = "spanner-db-user-sa"
#   db-service_account-name = "spanner-db-user-sa"
#   # depends_on = [
#   #   module.sre-cluster
#   # ]
# }

module "gke_cluster" {
  source          = "../../modules/kubernetes-engine"
  project_id      = var.project_id
  cluster_info    = var.cluster_info
  network         = module.network.network.self_link
  subnetwork      = module.subnetwork.subnet.self_link
  service_account = var.service_account
  private_cluster_config = [{
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.13.0.0/28"
  }]

  ip_allocation_policy = [{
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"
  }]

  node_pools = {
    linux_pool = {
      name               = "linux-pool"
      machine_type       = "e2-medium"
      disk_size_gb       = 100
      initial_node_count = 2
      min_node_count     = 1
      max_node_count     = 4
      labels             = { os = "linux" }
      taints = [
        {
          key    = "os"
          value  = "linux"
          effect = "NO_SCHEDULE"
        },
      ]
    },
    windows_pool = {
      name               = "windows-pool"
      machine_type       = "e2-standard-4"
      disk_size_gb       = 100
      initial_node_count = 1
      min_node_count     = 1
      max_node_count     = 2
      labels             = { os = "windows" }
      taints = [
        {
          key    = "os"
          value  = "windows"
          effect = "NO_SCHEDULE"
        },
      ]
      image_type = "WINDOWS_LTSC_CONTAINERD"
    }
  }
}
