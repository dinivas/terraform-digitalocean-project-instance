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

  name               = format("%s-%s-%s", var.project_name, var.instance_name, count.index)
  image              = var.instance_image_name
  size               = var.instance_flavor_name
  ssh_keys           = [var.instance_ssh_key_id]
  region             = var.project_availability_zone
  vpc_uuid           = var.instance_vpc_id
  user_data          = data.template_file.instance_user_data.0.rendered
  tags               = concat([var.project_name], split(",", format("consul_cluster_name_%s-%s,project_%s", var.project_name, "consul", var.project_name)))
  private_networking = true
}

