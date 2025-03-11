<h1 align="center" style="margin-top: 0px;">3-tier-GKE-Spanner</h1>
<div align="center">
<img width="100%" alt="image001" src="https://github.com/user-attachments/assets/bedf2526-4174-4c53-85ce-447390fa34ca" />
</div>

# About:
This project demonstrates the end-to-end automation of a robust, cloud-native application deployment on Google Cloud Platform (GCP). A three-tier architecture was implemented, featuring a private Google Kubernetes Engine (GKE) cluster for hosting an online boutique application and Google Cloud Spanner as the backend database. The entire infrastructure provisioning was automated using Terraform, with continuous integration (CI) facilitated by GitHub Actions. Application deployments to the GKE cluster were also automated using Helm and GitHub Actions, leveraging a self-hosted GitHub runner. This project showcases a fully automated, scalable, and secure application deployment pipeline on GCP.


# Pipelines:
| Terraform Readme Update Pipeline Status |
| --------------- |
| [![Generate terraform docs](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/readme.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/readme.yaml) |

| Infrastructure Pipeline Status |
| --------------- |
| [![Infrastructure CI](https://github.com/Mayur-1999/3-tier-GKE-SQL/actions/workflows/infra_ci.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-SQL/actions/workflows/infra_ci.yaml) |
| [![Infrastructure CD](https://github.com/Mayur-1999/3-tier-GKE-SQL/actions/workflows/infra_cd.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-SQL/actions/workflows/infra_cd.yaml) |

| Frontend Service Pipeline Status |
| --------------- |
|[![Frontend Service Build](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/frontend_ci.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/frontend_ci.yaml)|
|[![Frontend Service Deploy](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/frontend_cd.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/frontend_cd.yaml)|

| Other Application Pipeline Status |
| --------------- |
| [![Helm Build](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/applications_ci.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/applications_ci.yaml) |
| [![Helm Deploy](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/applications_cd.yaml/badge.svg)](https://github.com/Mayur-1999/3-tier-GKE-Spanner/actions/workflows/applications_cd.yaml) |



## Repo Secrets
| Secret | Description | Value|
|--------|-------------|------|
| SA_KEY | Service account Json Key for deploying infrastructure using terraform on GCP ([Required Permissions ]()) | JSON key | 

## Repo Variables
| Variables | Description | Value|
|-----------|-------------|------|
| SPANNER_DATABASE_NAME | Name of the database | `carts` |
| SPANNER_INSTANCE_NAME | Name of the spanner instance | `onlinebotique` |
| PROJECT_ID | Project ID | `N/A` |

## Environment Secrets
| Secret | Description | Value|
|--------|-------------|------|
| GKE_SA_KEY | Service account Json Key for deployment on the GKE Cluster ([Required Permissions ](https://docs.github.com/en/actions/use-cases-and-examples/deploying/deploying-to-google-kubernetes-engine)) | JSON key |
| SA_KEY | Service account Json Key for deploying infrastructure using terraform on GCP ([Required Permissions ]()) | JSON key | 

## Environment Variables
| Variables | Description | Value|
|-----------|-------------|------|
| GKE_CLUSTER_NAME | GKE CLuster name for application deployment | `N/A` |
| GKE_ZONE | GKE CLuster Zone | `us-east1-b` |
| PROJECT_ID | Project ID of the GCP project in which GKE Cluster is deployed | `N/A` |


## Create GKE service connection 

* create service account 
```
gcloud iam service-accounts create $SA_NAME
```

* Retrieve the email address of the service account you just created
```
gcloud iam service-accounts list
```

* Add roles to the service account 
```
gcloud projects add-iam-policy-binding $GKE_PROJECT \
  --member=serviceAccount:$SA_EMAIL \
  --role=roles/container.admin
gcloud projects add-iam-policy-binding $GKE_PROJECT \
  --member=serviceAccount:$SA_EMAIL \
  --role=roles/storage.admin
gcloud projects add-iam-policy-binding $GKE_PROJECT \
  --member=serviceAccount:$SA_EMAIL \
  --role=roles/container.clusterViewer
```

## Self-Hosted-GitHub-Runner
-- Note: Self hosted github runner is used in kubernetes deployment workflows as its a private cluster.

* create Linux VM & associated firewall 
```
variable "project_id" {
  type    = string
  default = "value"
}

resource "google_compute_instance" "github-runner" {
  name         = "self-hosted-runner"
  project      = var.project_id
  machine_type = "e2-medium"
  zone         = "us-east1-a"
  tags         = ["self-hosted-runner"]
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250213"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = "projects/${var.project_id}/regions/us-east1/subnetworks/subnet"
    access_config {}
  }

  service_account {
    email  = "${var.project_id}@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "runner-ssh-firewall" {
  project       = var.project_id
  description   = "firewall to ssh into github runner linux machine"
  name          = "runner-ssh-firewall"
  network       = "vpc"
  direction     = "INGRESS"
  source_ranges = "0.0.0.0/0"
  target_tags   = "self-hosted-runner"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }

  source_tags = ["web"]
}

```

* Install Kubectl, gloud & configure the kubernetes cluster
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update
sudo apt-get install google-cloud-cli -y
grep -rhE ^deb /etc/apt/sources.list* | grep "cloud-sdk"
sudo apt-get update
sudo apt-get install -y kubectl
```


* Add the machine as github runner.
```
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.322.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz
echo "b13b784808359f31bc79b08a191f5f83757852957dd8fe3dbfcc38202ccf5768  actions-runner-linux-x64-2.322.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.322.0.tar.gz


# runner configurations
./config.sh --url REPO_URL --token TOKEN
./run.sh
```

# Terraform Input ([terraform.tfvars](https://github.com/Mayur-1999/3-tier-GKE-Spanner/blob/Dev/Infrastructure/Env/Dev/terraform.tfvars))
| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_id         | GCP Project ID | `string` | "qwiklabs-gcp-02-a83ac4580055" |
| region             | Region to deploy GCP Services | `string` | "us-east1" | 
| service_account    | Service account for Kubernetes Engine | `string` | "qwiklabs-gcp-02-a83ac4580055@qwiklabs-gcp-02-a83ac4580055.iam.gserviceaccount.com" | 
| backend_bucket     | Name of Backend Bucket to store terraform state file | `string` | "tf-state-bkt-001" |
| create_vpc         | Create Network/VPC | `bool` | true       | 
| create_subnet      | Create subenetwork within the VPC| `bool` | true       |
| create_firewall    | Create firewalls for the VPC | `bool` | true       |
| create_nat-gateway | Create Network Address Translation Gateway | `bool` | true       |
| create_cluster     | Create a private kubernetes cluster within the Network with the specified ranges | `bool` | true       |
| create_spanner     | Create a spanner database | `bool` | true       |
| create_reserve-ip  | Reserve IP for External Load Balancer | `bool` | true       |
| create_cloud-armor | Create Cloud Armor rule for External Load Balancer| `bool` | false      |
| create_lb          | Create Loadbalancer | `bool` | false      | 
