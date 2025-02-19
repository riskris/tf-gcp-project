output "instance_name" {
  value = google_sql_database_instance.cloud_sql_instance.name
  description = "Name of the created Cloud SQL instance"
}

output "cloud_sql_database_names" {
  value = { for k, db in google_sql_database.cloud_sql_database : k => db.name } #db.self_link instead of db.name potentially?
  description = "Map of Cloud SQL database names"
}

#output "cloud_sql_database_name" {
#  value = google_sql_database.cloud_sql_database.name
#  description = "Name of the created Cloud SQL database within the Cloud SQl instance"
#}

