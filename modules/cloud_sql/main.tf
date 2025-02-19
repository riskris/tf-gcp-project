#updated cloud sql database instance resource. 
#activation_policy, availability_type, tier should only be under settings and not root level. 
#settings and backup_configuration should be blocks not attributes. there are no = in blocks. settings = {} is incorrect for the block. settings {} is correct

#create a cloud_sql_database_instance

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
            enabled = true
            start_time = var.backup_start_time
        }
  }
}

#create cloud_sql_database(s)
#we want to create multiple databases within a single cloud_sql instance. 
#for_each loop is placed around the google_sql_database resource which is inside the cloud_sql main.tf

resource "google_sql_database" "cloud_sql_database" {
  for_each = var.databases

  name     = each.key
  project  = var.project
  instance = google_sql_database_instance.cloud_sql_instance.name
  charset  = each.value.charset
  collation = each.value.collation
}

#resource "google_sql_database" "cloud_sql_database" {
#  name     = var.database_name 
#  project  = var.project
#  instance = google_sql_database_instance.cloud_sql_instance.name 
#  charset  = var.database_charset 
#  collation = var.database_collation 
#}
