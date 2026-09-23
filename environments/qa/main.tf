# ---------------------------------------------------------------------------
# Read the parent folder (v3feed) created by the dv environment state.
# This avoids recreating/conflicting with v3feed across environments.
# ---------------------------------------------------------------------------
data "terraform_remote_state" "dv" {
  backend = "gcs"

  config = {
    bucket = var.dv_state_bucket
    prefix = var.dv_state_prefix
  }
}

# ---------------------------------------------------------------------------
# Environment child folder: v3feed-qa  (nested under v3feed)
# ---------------------------------------------------------------------------
module "env_folder" {
  source = "../../modules/folder"

  parent_id   = data.terraform_remote_state.dv.outputs.parent_folder_id
  folder_name = "${var.parent_folder_name}-${var.env}"
}

# ---------------------------------------------------------------------------
# Projects nested under v3feed-qa: v3feed-qa-data, v3feed-qa-k8s, v3feed-qa-network
# ---------------------------------------------------------------------------
module "projects" {
  source   = "../modules/project"
  for_each = var.sub_projects

  project_id      = "${var.parent_folder_name}-${var.env}-${each.key}"
  project_name    = "${var.parent_folder_name}-${var.env}-${each.key}"
  folder_id       = module.env_folder.folder_id
  billing_account = var.billing_account
  enabled_apis    = each.value.enabled_apis
  labels = merge(
    each.value.labels,
    {
      environment = var.env
      managed_by  = "terraform"
    }
  )
}
