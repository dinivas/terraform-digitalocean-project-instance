data "digitalocean_vpc" "instance" {
  count = var.instance_count

  name = var.instance_network
}

data "digitalocean_ssh_key" "instance" {
  count = var.instance_count

  name = "${var.project_name}-project-keypair"
}


data "http" "generic_user_data_template" {
  url = var.generic_user_data_file_url
}


data "template_file" "instance_user_data" {
  count = var.instance_count

  template = data.http.generic_user_data_template.body

  vars = {
    cloud_provider            = "digitalocean"
    project_name              = var.project_name
    consul_agent_mode         = "client"
    consul_cluster_domain     = var.project_consul_domain
    consul_cluster_datacenter = var.project_consul_datacenter
    consul_cluster_name       = "${var.project_name}-consul"
    do_region                 = var.project_availability_zone
    do_api_token              = var.do_api_token
    enable_logging_graylog    = var.enable_logging_graylog

    pre_configure_script     = ""
    custom_write_files_block = ""
    post_configure_script    = ""
  }
}

resource "digitalocean_droplet" "instance" {
  count = var.instance_count

  name               = format("%s-%s", var.instance_name, count.index)
  image              = var.instance_image_name
  size               = var.instance_flavor_name
  ssh_keys           = [data.digitalocean_ssh_key.instance.0.id]
  region             = var.project_availability_zone
  vpc_uuid           = data.digitalocean_vpc.instance.0.id
  user_data          = data.template_file.instance_user_data.0.rendered
  tags               = concat([var.project_name], split(",", format("consul_cluster_name_%s-%s,project_%s", var.project_name, "consul", var.project_name)))
  private_networking = true
}

resource "null_resource" "instance_consul_client_leave" {
  count = var.instance_count

  triggers = {
    private_ip                         = digitalocean_droplet.instance[count.index].ipv4_address_private
    host_private_key                   = var.host_private_key
    bastion_host                       = lookup(var.ssh_via_bastion_config, "bastion_host")
    bastion_port                       = lookup(var.ssh_via_bastion_config, "bastion_port")
    bastion_ssh_user                   = lookup(var.ssh_via_bastion_config, "bastion_ssh_user")
    bastion_private_key                = var.bastion_private_key
    execute_on_destroy_instance_script = join(",", var.execute_on_destroy_instance_script)
  }

  connection {
    type        = "ssh"
    user        = "root"
    port        = 22
    host        = self.triggers.private_ip
    private_key = self.triggers.host_private_key
    agent       = false

    bastion_host        = self.triggers.bastion_host
    bastion_port        = self.triggers.bastion_port
    bastion_user        = self.triggers.bastion_ssh_user
    bastion_private_key = self.triggers.bastion_private_key
  }

  provisioner "remote-exec" {
    when       = destroy
    inline     = split(",", self.triggers.execute_on_destroy_instance_script)
    on_failure = continue
  }

}
