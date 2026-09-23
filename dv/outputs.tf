output "parent_folder_id" {
  description = "Resource name of the parent folder (v3feed) - consumed by qa/ut/pr/dr via remote state"
  value       = module.parent_folder.folder_id
}

output "env_folder_id" {
  description = "Resource name of the environment folder (v3feed-dv)"
  value       = module.env_folder.folder_id
}

output "project_ids" {
  description = "Map of sub-project key to created project id"
  value       = { for k, v in module.projects : k => v.project_id }
}

output "project_numbers" {
  description = "Map of sub-project key to project number"
  value       = { for k, v in module.projects : k => v.project_number }
}
