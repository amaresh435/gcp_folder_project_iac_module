variable "project_id" {
  description = "The globally unique project id, e.g. v3feed-dv-data"
  type        = string
}

variable "project_name" {
  description = "The display name of the project. Defaults to project_id when null"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The parent folder id in which the project is created, e.g. folders/{folder_id}"
  type        = string
}

variable "billing_account" {
  description = "The billing account id to associate with this project"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the project"
  type        = map(string)
  default     = {}
}

variable "enabled_apis" {
  description = "List of APIs/services to enable on the project"
  type        = list(string)
  default     = []
}

variable "auto_create_network" {
  description = "Whether to create the default VPC network for the project"
  type        = bool
  default     = false
}
