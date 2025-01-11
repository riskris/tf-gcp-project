output "network_id" {
  value = google_compute_network.default.id
}

output "subnet_ids" {
  value = {for k,v in google_compute_subnetwork.subnets : k => v.id} 
}

output "vms" {
  value = {for k,v in module.vm : k => {
    name = v.name
    id = v.id
    private_ip = v.private_ip
  }}
}

output "firewall_ids" {
  value = {for k,v in google_compute_firewall.firewall_rules : k => v.id}
}

output "storage_bucket_urls" {
  value = {for k,v in google_storage_bucket.buckets : k => v.url}
}