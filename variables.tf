variable "project" {
  type = string
  default = "tfgcp-test-project-25"
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "network_name" {
  type = string
  default = "my-vpc"
}

variable "subnets" {
  type = map(object({
    region = string
    ip_cidr = string
  }))
  default = {
    "my-subnet" = {
      region = "us-central1"
      ip_cidr = "10.128.0.0/20"
    }
  }
}

variable "firewall_rules" {
  type = map(object({
    description = optional(string)
    direction = string
    target_tags = optional(list(string))
    source_ranges = list(string)
    allow = optional(list(object({
      protocol = string
      ports = list(string)
    })))
    deny = optional(list(object({
      protocol = string
      ports = list(string)
    })))
  }))
  default = {
    "allow-ssh" = {
      description = "Allow SSH access from your local machine"
      direction = "INGRESS"
      source_ranges = ["0.0.0.0/0"] 
      allow = [
        {
          protocol = "tcp"
          ports = ["22"]
        }
      ]
    }
  }
}

variable "storage_buckets" {
  type = map(object({
    location = string
    storage_class = string
    labels = map(string)
    versioning_enabled = bool
  }))
  default = {
    "tfgcp_bucket1_25" = {
      location = "US"
      storage_class = "STANDARD"
      labels = {
        "environment" = "dev"
        "team" = "devops"
      }
      versioning_enabled = true
    }
    "tfgcp_bucket2_25" = {
      location = "US"
      storage_class = "NEARLINE"
      labels = {
        "environment" = "prod"
        "team" = "data"
      }
      versioning_enabled = true
    }
  }
}

variable "vms" {
  type = map(object({
    subnet = string
    zone = string
    machine_type = string
    image = string
  }))
  default = {
    "my-vm" = {
      subnet = "my-subnet"
      zone = "c"
      machine_type = "n1-standard-1"
      image = "debian-cloud/debian-11"
    }
  }
}

variable "cloud_sql_databases" {
  type = map(object({
    charset  = string
    collation = string
    # Add other database-specific settings as needed
  }))
  description = "Map of Cloud SQL database configurations"
  default = {
    "database1" = {
      charset  = "utf8mb4"
      collation = "utf8mb4_general_ci"
    }
    "database2" = {
      charset  = "latin1"
      collation = "latin1_swedish_ci"
    }
  }
}

variable "cloud_sql_instance_name" {
  type = string
  description = "Name of the Cloud SQL instance"
  default = "TEST_INSTANCE_1" 
}

variable "cloud_sql_database_version" {
  type = string
  description = "Database version for Cloud SQL"
  default = "MYSQL_8_0" 
}

variable "cloud_sql_tier" {
  type = string
  description = "Tier/machine type for Cloud SQL instance"
  default = "db-f1-micro" 
}

# Add a variable for deletion protection
variable "cloud_sql_deletion_protection" {
  type = bool
  description = "Enable deletion protection for the Cloud SQL Instance"
  default = false
}

variable "cloud_sql_activation_policy" {
  type = string
  description = "Activation policy for the Cloud SQL instance"
  default = "ALWAYS" # Provide a default value
}

variable "cloud_sql_availability_type" {
  type = string
  description = "Availability type for the Cloud SQL instance"
  default = "ZONAL" # Provide a default value
}

variable "cloud_sql_backup_start_time" {
  type = string
  description = "Start time for daily backups"
  default = "02:00" # Provide a default value
}

#variable "cloud_sql_database_name" {
#  type = string
#  description = "Name of the Cloud SQL database"
#}

#variable "cloud_sql_database_charset" {
#  type = string
#  description = "Charset of the Cloud SQL database"
#  default = "utf8mb4"
#}

#variable "cloud_sql_database_collation" {
#  type = string
#  description = "Collation of the Cloud SQL database"
#  default = "utf8mb4_general_ci"
#}