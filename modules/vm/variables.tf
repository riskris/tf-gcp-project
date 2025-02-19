
#VARIABLES BLOCK

#placeholders for values you provide when using the module
#used within the module itself to configure resources
#in the module.tf reference the variables within the google_compute_instance resource
#for example: project = var.project sets the project ID for the VM instance using the project variable we've defined
#the module block in main.tf doesn't directly receive these variables. It serves as a refrence point to the module and can optionally provide values for some of its variables
#if we dont provide valeus for variables in the module block, the module will use the default values defined within the variable block. 

#define a variable named subnet_id with a type string.
variable "subnet_id" {
  type = string
}

#define a variable named project with a type string and a default value
variable "project" {
  type = string
  default = "tfgcp-test-project-25"  #project_id in GCP
}

#define a variable named zone with a type string and a default value
variable "zone" {
  type = string
  default = "us-central1-a"  
}

#define a variable named vm_name with a string type and a default value
variable "vm_name" {
  type = string
  default = "my-vm"
}

#define a variable named machine_type with a string type and a default value
variable "machine_type" {
  type = string
  default = "n1-standard-1"
}

#define a variable named image with a string type and default value
variable "image" {
  type = string
  default = "debian-cloud/debian-11"
}

#cloud_sql_instance_name value that is being passed from root main.tf
variable "cloud_sql_instance_name" {
  type = string
  description = "Name of the Cloud SQL instance"
}

variable "cloud_sql_region" {
    type = string
    description = "Region of the Cloud SQL instance"
}