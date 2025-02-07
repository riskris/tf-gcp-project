#moved the variables from this module to variables.tf
#RESOURCE BLOCK

resource "google_compute_instance" "vm_instance" { #defines the overall VM instance (which has various components like boot disk and network interface)
  project = var.project #sets the project ID for the VM instance, referencing the project variable defined. 
  zone    = var.zone #sets the zone for the VM instance, referencing the zone variable defined.
  name    = var.vm_name #sets the name for the VM instance, referencing the vm_name variable defined.
  machine_type = var.machine_type #sets the name for the machine type for the VM instance, referencing the machine_type variable defined. 
  boot_disk {  #nested block allowing you to group related configurations under the main resource. boot_disk {...} block focuses on configurating the boot disk for the VM.
    initialize_params { #this block is nested within the boot_disk block. It's part of the boot_disk argument and defines how the boot disk should be initalized. specifies that boot disk should be created using an operating system image. 
      image = var.image #sets image property within the initialize_params block. References the image variable defined in variables block to specify the image for the boot disk.
    }
  }
  network_interface { #part of the google_compute_instance resource definition in the module file.m Defines the network interface for the VM.  
    subnetwork = var.subnet_id #sets the property of the network interface. var.subnet_id references the subnet_id variable. VM instance will be attached to the subnetwork whose ID is provided inthe subnet_id variable. 
  }
}