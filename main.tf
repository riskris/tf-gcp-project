# Configure the Google Cloud Provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

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

# Create a Cloud Storage bucket
resource "google_storage_bucket" "my_tfgcp_bucket" {
  name          = "my_tfgcp_bucket25"
  location     = "US" 
}