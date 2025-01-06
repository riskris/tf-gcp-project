# Configure the Google Cloud Provider

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.85.0" 
    }
  }
}

# Typically for Google Cloud I don't put the project and region in the provider and put them in the resources as well
# this then allows the same provider to be used for multiple projects and regions.  If you removed the default values
# you would need to add them into the resources though
provider "google" {
  project = "tfgcp-test-project-25" 
  region  = "us-central1"        
}

# Create a VPC network
resource "google_compute_network" "default" {
  name                    = "my-vpc"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC
resource "google_compute_subnetwork" "default" {
  name          = "my-subnet"
  ip_cidr_range = "10.128.0.0/20"
  # Set the desired region explicitly
  region        = "us-central1"  # Replace with your desired region
  network       = google_compute_network.default.name
  project       = "tfgcp-test-project-25" 
}

# Create a VM instance
resource "google_compute_instance" "example" {
  name         = "my-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a" 

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
  }
}

# Create a firewall rule to allow SSH access
#two different approaches to configuring a firewall rule for SSH access in TF. 
#scenario 1. temporary access scenario (0.0.0.0/0) 2:controlled access (Specific IP)

resource "google_compute_firewall" "ssh_access" {
  name        = "allow-ssh"
  description = "Allow SSH access from your local machine"

  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction ="INGRESS"
  source_ranges = ["0.0.0.0/0"]  # Replace with your actual IP
  #target_tags = ["ssh_access"]
}


# Create a Cloud Storage bucket
resource "google_storage_bucket" "my_tfgcp_bucket2" {
  for_each = {
    "tfgcp_bucket1_25" = {
      location = "US"
      storage_class = "STANDARD"
      labels = {
        "environment" = "dev"
        "team" = "devops"
      }
      versioning_enabled = true # the for_each variable setting doesn't have to align with how it is used in the config so I simplified
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

  name = each.key
  location = each.value.location
  storage_class = each.value.storage_class
  labels = each.value.labels

  # added dynamic block here which will exist if versioning_enabled is true and not exist if false
  # see https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
  dynamic "versioning" {
    for_each = each.value.versioning_enabled == true ? [""] : []
    content {
      enabled = true
    }
  }
}