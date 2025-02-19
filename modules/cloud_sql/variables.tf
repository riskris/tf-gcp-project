
variable "project" {
    type = string
    description = "GCP project ID"
}

variable "region" {
    type = string
    description = "Region for the Cloud SQL instance"
}

variable "instance_name" {
    type = string
    description = "Name for the Cloud SQL instance"
}

variable "database_version" {
    type = string
    description = "Database engine version (e.g., MYSQL_11_1)"
}

variable "tier" {
    type = string
    description = "Machine type tier for the Cloud SQL instance (e.g., db-n1-standard-1) "
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

variable "deletion_protection" {
  description = "Enable deletion protection for the Cloud SQL instance"
}

#creating cloud_sql databases

variable "databases" {
  type = map(object({
    charset  = string
    collation = string
    # Add other database-specific settings as needed
  }))
  description = "Map of Cloud SQL database configurations"
}

#variable "database_name" {
#  type = string
#  description = "The name of the Cloud SQL database to create."
#}

#variable "database_charset" {
#  type = string
#  description = "The charset for the database."
#  default = "utf8mb4" 
#}

#variable "database_collation" {
#  type = string
#  description = "The collation for the database."
#  default = "utf8mb4_general_ci" 
#}