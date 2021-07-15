variable "do_api_token" {}

module "dinivas_project_instance" {
  source = "../../"

  project_name               = "dnv"
  instance_name              = "test"
  project_availability_zone = "fra1"
  instance_vpc_id            = "fdb4de81-c7fe-4545-8400-4e1282a374be"
  instance_image_name        = 87674237
  instance_flavor_name       = "s-1vcpu-1gb"
  instance_ssh_key_id        = 30823813
  project_consul_domain      = "dinivas.io"
  project_consul_datacenter  = "fra1"
  enable_logging_graylog     = "1"
  do_api_token               = var.do_api_token
}
