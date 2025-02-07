resource "google_sql_database_instance" "cloud_sql_instance" {
  name               = var.instance_name
  project            = var.project
  region             = var.region
  network = var.network_name 
  database_version   = var.database_version
  tier              = var.tier
  activation_policy = var.activation_policy
  availability_type = var.availability_type 

  settings = {
    tier              = var.tier 
    activation_policy = var.activation_policy
    backup_configuration = {
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