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





module "cloud_sql" {
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

# resource "google_sql_database_instance" "mycloudsql_instance_name" {
#   project = var.project 
#   name = var.cloud_sql_instance_name
#   region = var.region
#   database_version = var.cloud_sql_database_version
#   deletion_protection = var.cloud_sql_deletion_protection
#   settings {
#     tier = var.cloud_sql_tier
#   }
# }


module "vm" {
  source = "./modules/vm"
  project = var.project
  for_each = var.vms
    vm_name = each.key
  zone = "${google_compute_subnetwork.subnets[each.value.subnet].region}-${each.value.zone}"
  machine_type = each.value.machine_type
  image = each.value.image
  subnet_id = google_compute_subnetwork.subnets[each.value.subnet].id
}


