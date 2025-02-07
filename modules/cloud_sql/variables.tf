variable "project" {
  description = "GCP project ID"
}

variable "region" {
  description = "Region for the Cloud SQL instance"
}

variable "instance_name" {
  description = "Name for the Cloud SQL instance"
}

variable "database_version" {
  description = "Database engine version (e.g., MYSQL_11_1)"
}

variable "tier" {
  description = "Machine type tier for the Cloud SQL instance (e.g., db-n1-standard-1)"
}

variable "activation_policy" {
  description = "Activation policy (e.g., ALWAYS)"
}

variable "availability_type" {
  description = "Availability type (e.g., REGIONAL)"
}

variable "backup_start_time" {
  description = "Start time for daily backups (e.g., '02:00')"
}

#variable "cloud_sql_users" {
#  type = list(object({
#    name     = string
#    password = string
#    host     = string
#    grant    = object({
#      database = string
#      privilege = string
#    })
#  }))

#  description = "List of user configurations for the Cloud SQL instance"
#}