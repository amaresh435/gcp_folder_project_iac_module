# Configure this backend for the target project before running terraform init.
terraform {
  backend "gcs" {
    bucket = "gcp-tfm-resources"
    prefix = "gcp_folder_proj_v3feed/pr"
  }
}
