output "instance_instance_ids" {
  value = digitalocean_droplet.instance.*.id
}

output "instance_public_ip_v4" {
  value = digitalocean_droplet.instance.*.ipv4_address
}

output "instance_private_ip_v4" {
  value = digitalocean_droplet.instance.*.ipv4_address_private
}

