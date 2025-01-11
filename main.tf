
# Create a VPC network
resource "google_compute_network" "default" {
  project = var.project
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Create subnet(s) within the VPC
resource "google_compute_subnetwork" "subnets" {
  project       = var.project
  for_each = var.subnets
  region        = var.region
  name          = each.key
  ip_cidr_range = each.value.ip_cidr
  network       = google_compute_network.default.name
}

module "vm" {
  source = "./modules/vm"
  project       = var.project
  for_each = var.vms

  vm_name = each.key
  zone = "${google_compute_subnetwork.subnets[each.value.subnet].region}-${each.value.zone}"
  machine_type = each.value.machine_type
  image = each.value.image
  subnet_id = google_compute_subnetwork.subnets[each.value.subnet].id
}


resource "google_compute_firewall" "firewall_rules" {
  project       = var.project
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


# Create a Cloud Storage bucket
resource "google_storage_bucket" "buckets" {
  project       = var.project
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