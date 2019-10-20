data "openstack_networking_network_v2" "instance_network" {
  count = "${var.enable_instance}"

  name = "${var.instance_network}"
}

data "openstack_networking_subnet_v2" "instance_subnet" {
  count = "${var.enable_instance}"

  name = "${var.instance_subnet}"
}

data "http" "generic_user_data_template" {
  url = "${var.generic_user_data_file_url}"
}


data "template_file" "instance_user_data" {
  count = "${var.instance_count}"

  template = "${data.http.generic_user_data_template.body}"

  vars = {
    consul_agent_mode         = "client"
    consul_cluster_domain     = "${var.project_consul_domain}"
    consul_cluster_datacenter = "${var.project_consul_datacenter}"
    consul_cluster_name       = "${var.project_name}-consul"
    os_auth_domain_name       = "${var.os_auth_domain_name}"
    os_auth_username          = "${var.os_auth_username}"
    os_auth_password          = "${var.os_auth_password}"
    os_auth_url               = "${var.os_auth_url}"
    os_project_id             = "${var.os_project_id}"

    pre_configure_script     = ""
    custom_write_files_block = ""
    post_configure_script    = ""
  }
}

module "project_instance" {
  source = "github.com/dinivas/terraform-openstack-instance"

  instance_name                 = "${var.instance_name}"
  instance_count                = "${var.instance_count}"
  image_name                    = "${var.instance_image_name}"
  flavor_name                   = "${var.instance_flavor_name}"
  keypair                       = "${var.instance_keypair_name}"
  network_ids                   = ["${data.openstack_networking_network_v2.instance_network.0.id}"]
  subnet_ids                    = ["${data.openstack_networking_subnet_v2.instance_subnet.*.id}"]
  instance_security_group_name  = "${var.instance_name}-sg"
  instance_security_group_rules = "${var.instance_security_group_rules}"
  security_groups_to_associate  = "${var.instance_security_groups_to_associate}"
  user_data                     = "${data.template_file.instance_user_data.0.rendered}"

  metadata = "${merge(var.instance_metadata, map("consul_cluster_name", format("%s-%s", var.project_name, "consul")), map("project", var.project_name))}"

  enabled                            = "${var.enable_instance}"
  availability_zone                  = "${var.instance_availability_zone}"
  execute_on_destroy_instance_script = "${var.execute_on_destroy_instance_script}"
  ssh_via_bastion_config             = "${var.ssh_via_bastion_config}"
}
