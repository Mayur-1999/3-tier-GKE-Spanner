
resource "google_spanner_instance" "sre-spanner" {
 config = var.config
 display_name = var.display_name
 name = "onlineboutique"
 num_nodes = var.num_nodes
}

# Spanner database and table

resource "google_spanner_database" "sre-database" {
 instance = google_spanner_instance.sre-spanner.name
 name = var.database_name
 version_retention_period = "3d"
 ddl = [
 "CREATE TABLE CartItems (userId STRING(1024), productId STRING(1024), quantity INT64) PRIMARY KEY (userId, productId)",
 "CREATE INDEX CartItemsByUserId ON CartItems(userId)",
 ]
 deletion_protection = false
}

# Create a service account
resource "google_service_account" "sa" {
 account_id = var.db-service_account-id
 display_name = var.db-service_account-name
 
}


# database policy Bindings
data "google_iam_policy" "admin" {
 binding {
 role = "roles/spanner.databaseUser"
 members = [
 "serviceAccount:${google_service_account.sa.email}",
 ]
 }
}

resource "google_spanner_database_iam_policy" "admin-account-iam" {
 instance = google_spanner_instance.sre-spanner.name
 database = google_spanner_database.sre-database.name
 policy_data = data.google_iam_policy.admin.policy_data
}

# service iam policy Bindings
data "google_iam_policy" "admin1" {
 binding {
 role = "roles/iam.workloadIdentityUser"
 members = [
 "serviceAccount:qwiklabs-gcp-04-5dc03957119b.svc.id.goog[default/cartservice]",
 ]
 }
}

resource "google_service_account_iam_policy" "admin-account-iam" {
 service_account_id = google_service_account.sa.name
 policy_data = data.google_iam_policy.admin1.policy_data
}

