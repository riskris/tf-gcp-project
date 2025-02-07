output "name" {
  value = google_compute_instance.vm_instance.name
}

output "id" {
  value = google_compute_instance.vm_instance.id
}

output "private_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].network_ip
}