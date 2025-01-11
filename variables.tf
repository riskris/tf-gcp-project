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
      zone = "a"
      machine_type = "n1-standard-1"
      image = "debian-cloud/debian-11"
    }
  }
}

