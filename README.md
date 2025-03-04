<h1 align="center" style="margin-top: 0px;">3-tier-GKE-Spanner</h1>
<div align="center">
<img width="100%" alt="image001" src="https://github.com/user-attachments/assets/bedf2526-4174-4c53-85ce-447390fa34ca" />
</div>

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


## Repo Secrets
| Secret | Description | Value|
|--------|-------------|------|
| SA_KEY | Service account Json Key for deploying infrastructure using terraform on GCP ([Required Permissions ]()) | JSON key | 

## Repo Variables
| Variables | Description | Value|
|-----------|-------------|------|
| SPANNER_DATABASE_NAME | Name of the database | `carts` |
| SPANNER_INSTANCE_NAME | Name of the spanner instance | `onlinebotique` |

## Environment Secrets
| Secret | Description | Value|
|--------|-------------|------|
| GKE_SA_KEY | Service account Json Key for deployment on the GKE Cluster ([Required Permissions ](https://docs.github.com/en/actions/use-cases-and-examples/deploying/deploying-to-google-kubernetes-engine)) | JSON key |
| SA_KEY | Service account Json Key for deploying infrastructure using terraform on GCP ([Required Permissions ]()) | JSON key | 

## Environment Variables
| Variables | Description | Value|
|-----------|-------------|------|
| GKE_CLUSTER_NAME | GKE CLuster name for application deployment | `cluster-name` |
| GKE_ZONE | GKE CLuster Zone | `us-central1-a` |
| PROJECT_ID | Project ID of the GCP project in which GKE Cluster is deployed | `project-id` |


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

## Pipelines 