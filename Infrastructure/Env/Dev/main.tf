module "network" {
  count      = var.create_vpc ? 1 : 0
  source     = "../../modules/vpc"
  project_id = var.project_id
  vpc_info   = var.vpc_info
}

module "subnetwork" {
  count       = var.create_subnet ? 1 : 0
  source      = "../../modules/subnet"
  project_id  = var.project_id
  region      = var.region
  network     = module.network[0].network
  subnet_info = var.subnet_info
  depends_on = [
    module.network
  ]
}

module "app-firewall" {
  count         = var.create_firewall ? 1 : 0
  source        = "../../modules/firewall"
  project_id    = var.project_id
  network       = module.network[0].network
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
  count         = var.create_firewall ? 1 : 0
  source        = "../../modules/firewall"
  project_id    = var.project_id
  network       = module.network[0].network
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
  count        = var.create_nat-gateway ? 1 : 0
  source       = "../../modules/nat-gateway"
  project_id   = var.project_id
  region       = var.region
  network      = module.network[0].network
  gateway_name = "nat-gateway"
}

module "spanner" {
  count                   = var.create_spanner ? 1 : 0
  source                  = "../../modules/spanner"
  config                  = "regional-${var.region}"
  display_name            = "onlineboutique"
  project_id              = var.project_id
  num_nodes               = 1
  database_name           = "carts"
  db-service_account-id   = "spanner-db-user-sa"
  db-service_account-name = "spanner-db-user-sa"
  depends_on = [
    module.gke_cluster
  ]
}

module "gke_cluster" {
  count           = var.create_cluster ? 1 : 0
  source          = "../../modules/kubernetes-engine"
  project_id      = var.project_id
  region          = var.region
  cluster_info    = var.cluster_info
  network         = module.network[0].network
  subnetwork      = module.subnetwork[0].subnet
  service_account = var.service_account
  private_cluster_config = [{
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.1.0.0/28"
  }]

  ip_allocation_policy = [{
    cluster_ipv4_cidr_block  = "10.2.0.0/21"
    services_ipv4_cidr_block = "10.3.0.0/21"
  }]

  node_pools = {
    linux_pool = {
      name               = "linux-pool"
      machine_type       = "e2-medium"
      disk_size_gb       = 50
      initial_node_count = 2
      min_node_count     = 1
      max_node_count     = 4
      locations          = ["us-central1-a", "us-central1-b"]
      labels             = { os = "linux" }
      taint = [
        {
          key    = "os"
          value  = "linux"
          effect = "NO_SCHEDULE"
        },
      ]
    }
  }
}

module "reserved_external_frontend_ip" {
  count      = var.create_reserve-ip ? 1 : 0
  source     = "../../modules/reserve-ip"
  ip_name    = "frontend-external-ip"
  project_id = var.project_id
}
