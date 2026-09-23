variable "parent_id" {
  description = "The resource name of the parent Folder or Organization, e.g. folders/{folder_id} or organizations/{org_id}"
  type        = string
}

variable "folder_name" {
  description = "The folder's display name"
  type        = string
}
