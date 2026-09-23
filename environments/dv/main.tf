# ---------------------------------------------------------------------------
# Parent folder: v3feed  (created ONCE here in dv; other envs read it via
# remote state instead of recreating it — see qa/ut/pr/dr main.tf)
# ---------------------------------------------------------------------------
module "parent_folder" {
  source = "../../modules/folder"

  parent_id   = "788877808915"
  folder_name = var.parent_folder_name
}

# ---------------------------------------------------------------------------
# Environment child folder: v3feed-dv  (nested under v3feed)
# ---------------------------------------------------------------------------
module "env_folder" {
  source = "../../modules/folder"

  parent_id   = module.parent_folder.folder_id
  folder_name = "${var.parent_folder_name}-${var.env}"
}

# ---------------------------------------------------------------------------
# Projects nested under v3feed-dv: v3feed-dv-data, v3feed-dv-k8s, v3feed-dv-network
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
