output "folder_id" {
  description = "The folder id in the format folders/{folder_id}"
  value       = google_folder.this.name
}

output "folder_display_name" {
  description = "The folder's display name"
  value       = google_folder.this.display_name
}
