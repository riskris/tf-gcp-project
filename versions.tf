#TERRAFORM BLOCK
#specifies Terraform version, required provders (GCP), source of the provider, and the version of the google provider. 
#versions.tf should be in every module and submodule. 
#versions.tf within a module allows you to declare the exact Terraform and provider versions that particular module is comparitble with. 

terraform {
  required_version = ">= 1.8.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.85.0" 
    }
  }
}