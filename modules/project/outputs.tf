output "project_id" {
  description = "The project id"
  value       = google_project.this.project_id
}

output "project_number" {
  description = "The numeric identifier for the project"
  value       = google_project.this.number
}

output "project_name" {
  description = "The display name of the project"
  value       = google_project.this.name
}
