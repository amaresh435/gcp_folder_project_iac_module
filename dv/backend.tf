terraform {
  backend "gcs" {
    bucket = "gcp-tfm-resources"
    prefix = "Gcp.Folder.Proj.v3feed/dv"
  }
}
