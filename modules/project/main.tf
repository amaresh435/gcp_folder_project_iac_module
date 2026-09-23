resource "google_project" "this" {
  name                = coalesce(var.project_name, var.project_id)
  project_id          = var.project_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  labels              = var.labels
  auto_create_network = var.auto_create_network
}

resource "google_project_service" "apis" {
  for_each = toset(var.enabled_apis)

  project = google_project.this.project_id
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}
