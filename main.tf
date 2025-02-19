# Create a VPC network
resource "google_compute_network" "default" {
  project = var.project
  name = var.network_name
  auto_create_subnetworks = false
}

# Create subnet(s) within the VPC

# Create subnet(s) within the VPC
resource "google_compute_subnetwork" "subnets" {
  project       = var.project
  for_each = var.subnets
  region        = var.region
  name          = each.key
  ip_cidr_range = each.value.ip_cidr
  network       = google_compute_network.default.name
}

#fixed module invocation

module "cloud_sql" {
  
  #instance level settings for configuration of the Cloud SQL instance, not the individual databases
  source = "./modules/cloud_sql"
  project = var.project
  instance_name = var.cloud_sql_instance_name
  region = var.region
  database_version = var.cloud_sql_database_version
  tier = var.cloud_sql_tier
  deletion_protection = var.cloud_sql_deletion_protection
  activation_policy = var.cloud_sql_activation_policy
  availability_type = var.cloud_sql_availability_type
  backup_start_time = var.cloud_sql_backup_start_time

  databases = var.cloud_sql_databases #pass the map of database.
  
  #database_name = var.cloud_sql_database_name  # Pass the database name
  #database_charset = var.cloud_sql_database_charset # Pass the Charset
  #database_collation = var.cloud_sql_database_collation # Pass the Collation

}



resource "google_compute_firewall" "firewall_rules" {
  project = var.project
  for_each = var.firewall_rules
  name        = each.key
  description = each.value.description
  network = google_compute_network.default.name
  direction = each.value.direction
  source_ranges = each.value.source_ranges
  target_tags = each.value.target_tags

  dynamic "allow" {

    for_each = each.value.allow != null ? each.value.allow : []
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny != null ? each.value.deny : []
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}

resource "google_storage_bucket" "buckets" {
  project = var.project
  for_each = var.storage_buckets
  name = each.key
  location = each.value.location
  storage_class = each.value.storage_class
  labels = each.value.labels
  uniform_bucket_level_access = true
  dynamic "versioning" {
    for_each = each.value.versioning_enabled == true ? [""] : []
    content {
      enabled = true
    }
  }
}

#updated resource configuration that would be used if the cloud sql module was not present.
#resource "google_sql_database_instance" "mycloudsql_instance1" {
#  project = var.project
#  name = var.cloud_sql_instance_name
#  region = var.region
#  database_version = var.cloud_sql_database_version
#  deletion_protection = var.cloud_sql_deletion_protection
#  settings {
#    tier = var.cloud_sql_tier
#  }
#}


#invocation of module "vm"
#we want to have the ability to create multiple vms. 
#for_each loop is placed around the google_compute_instance resource (or a module call that creates the instance inside the vm modules's main.tf)

module "vm" {
  source = "./modules/vm"
  project = var.project
  for_each = var.vms
    vm_name = each.key
  zone = "${google_compute_subnetwork.subnets[each.value.subnet].region}-${each.value.zone}"
  machine_type = each.value.machine_type
  image = each.value.image
  subnet_id = google_compute_subnetwork.subnets[each.value.subnet].id

#pass the clouds_sql_instance information to vm module. connecting VM to cloud_sql instance. 

  cloud_sql_instance_name = module.cloud_sql.instance_name
  cloud_sql_region = var.region
}


