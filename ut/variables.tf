variable "org_id" {
  description = "The GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account id to associate with all projects"
  type        = string
  default     = ""
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"
}

variable "parent_folder_name" {
  description = "Display name of the top-level parent folder"
  type        = string
  default     = "v3feed"
}

variable "env" {
  description = "Environment short name (dv, qa, ut, pr, dr)"
  type        = string
  default     = "ut"
}

variable "dv_state_bucket" {
  description = "GCS bucket holding the dv environment remote state (where v3feed parent folder is created)"
  type        = string
}

variable "dv_state_prefix" {
  description = "GCS prefix holding the dv environment remote state"
  type        = string
  default     = "gcp_folder_project_iac_module/dv"
}

variable "sub_projects" {
  description = "Map of sub-project suffixes to config (e.g. data, k8s, network)"
  type = map(object({
    enabled_apis = list(string)
    labels       = optional(map(string), {})
  }))
  default = {
    data = {
      enabled_apis = [
        "bigquery.googleapis.com",
        "storage.googleapis.com",
      ]
      labels = { workload = "data" }
    }
    k8s = {
      enabled_apis = [
        "container.googleapis.com",
        "compute.googleapis.com",
      ]
      labels = { workload = "k8s" }
    }
    network = {
      enabled_apis = [
        "compute.googleapis.com",
        "servicenetworking.googleapis.com",
        "dns.googleapis.com",
      ]
      labels = { workload = "network" }
    }
  }
}
