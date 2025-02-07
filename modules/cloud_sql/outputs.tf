output "instance_name" {
  value = google_sql_database_instance.cloud_sql_instance.name
  description = "Name of the created Cloud SQL instance"
}