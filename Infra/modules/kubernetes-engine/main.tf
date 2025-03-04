# Create GKE cluster with 2 nodes in our custom VPC/Subnet
resource "google_container_cluster" "cluster" {
  project                  = var.project_id
  name                     = var.cluster_info.name
  master_version           = var.cluster_info.master_version
  location                 = var.cluster_info.location #"asia-south2-a"
  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = var.cluster_info.remove_default_node_pool #true       
  initial_node_count       = var.cluster_info.initial_node_count       #1

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config
    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint #true
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes    #true
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block  #"10.13.0.0/28"
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy
    content {
      cluster_ipv4_cidr_block  = ip_allocation_policy.value.cluster_ipv4_cidr_block  # "10.11.0.0/21"
      services_ipv4_cidr_block = ip_allocation_policy.value.services_ipv4_cidr_block # "10.12.0.0/21" 
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

}


resource "google_container_node_pool" "node_pool" {
  for_each       = var.node_pools
  name           = each.value.name
  location       = var.cluster_info.location
  cluster        = google_container_cluster.cluster.name
  node_locations = var.cluster_info.locations
  #version        = var.node_version
  node_config {
    machine_type = each.value.machine_type
    preemptible  = lookup(each.value, "preemptible", false)
    disk_size_gb = each.value.disk_size_gb
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    labels = each.value.labels

    dynamic "taints" {
      for_each = lookup(each.value, "taints", [])
      content {
        key    = taints.key
        value  = taints.value
        effect = taints.effect
      }
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    image_type = lookup(each.value, "image_type", null)
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  initial_node_count = each.value.initial_node_count
  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }
}




# # Create managed node pool
# resource "google_container_node_pool" "cluster_nodes" {
#   name       = var.node_pool_info.name #google_container_cluster.cluster.name
#   version    = var.node_pool_info.version
#   location   = var.node_pool_info.location #"asia-south2-a"
#   cluster    = google_container_cluster.cluster.name
#   node_count = var.node_pool_info.var.node_count # 3



#   node_config {
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
#     disk_size_gb = var.node_pool_info.disk_size_gb # 50
#     disk_type    = var.node_pool_info.disk_type    #"pd-ssd"
#     machine_type = var.node_pool_info.machine_type #"n1-standard-1"
#     #service_account = google_service_account.mysa.email
#   }

#   dynamic "autoscaling" {
#     for_each = var.autoscaling
#     content {
#       min_node_count = autoscaling.value.min_node_count
#       max_node_count = autoscaling.value.max_node_count
#     }
#   }

#   management {
#     auto_repair  = true
#     auto_upgrade = false
#   }
# }
