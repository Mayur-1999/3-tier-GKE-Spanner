resource "google_container_cluster" "cluster" {
  project                  = var.project_id
  name                     = var.cluster_info.name
  location                 = var.zone
  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = var.cluster_info.remove_default_node_pool #true       
  initial_node_count       = var.cluster_info.initial_node_count       #1

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config
    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint #true
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes    #true
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false
  }

  release_channel {
    channel = var.cluster_info.release_channel
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
  location       = var.zone
  cluster        = google_container_cluster.cluster.name
  node_locations = each.value.locations
  node_config {
    machine_type    = each.value.machine_type
    preemptible     = lookup(each.value, "preemptible", false)
    disk_size_gb    = each.value.disk_size_gb
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    labels = each.value.labels

    dynamic "taint" {
      for_each = lookup(each.value, "taint", [])
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    image_type = lookup(each.value, "image_type", null)
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  initial_node_count = each.value.initial_node_count
  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }
}

