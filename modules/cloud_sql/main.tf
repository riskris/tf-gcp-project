resource "google_sql_database_instance" "cloud_sql_instance" {
  name               = var.instance_name
  project            = var.project
  region             = var.region
  database_version   = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier 
    activation_policy = var.activation_policy
    availability_type = var.availability_type 
    backup_configuration {
      start_time = var.backup_start_time 
    }
  }

  # ... other configurations for the Cloud SQL instance (optional)
}

#resource "google_sql_user" "user" {
#  for_each = var.cloud_sql_users

#  name     = each.value.name
#  instance = google_sql_database_instance.cloud_sql_instance.name
#  project  = var.project
#  password = each.value.password
#  host     = each.value.host
#  grant    = each.value.grant
#}