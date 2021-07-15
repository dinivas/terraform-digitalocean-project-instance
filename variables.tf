variable "project_name" {
  description = "The project this Instance belong to"
  type        = string
}

variable "instance_name" {
  description = "The name of the compute instance"
  type        = string
}

variable "instance_image_name" {
  description = "The Image name of the Instance"
  type        = string
}

variable "instance_flavor_name" {
  description = "The Flavor name of the Instance"
  type        = string
}

variable "instance_ssh_key_id" {
  description = "The SSH Key to use with the instance."
  type        = string
}

variable "instance_count" {
  type        = string
  description = "The number of instance."
  default     = "1"
}
variable "enable_logging_graylog" {
  type        = string
  default     = "0"
}

variable "project_availability_zone" {
  description = "The availability zone"
  type        = string
}

variable "instance_vpc_id" {
  description = "The VPC Id for the instance"
  type        = string
}

# Project Consul variables

variable "project_consul_domain" {
  type        = string
  description = "The domain name to use for the Consul cluster"
}

variable "project_consul_datacenter" {
  type        = string
  description = "The datacenter name for the consul cluster"
}

# Auth variables used by consul

variable "do_api_token" {
  type = string
}

variable "generic_user_data_file_url" {
  type    = string
  default = "https://raw.githubusercontent.com/dinivas/terraform-shared/master/templates/generic-user-data.tpl"
}

variable "execute_on_destroy_instance_script" {
  type    = string
  default = ""
}

variable "ssh_via_bastion_config" {
  description = "config map used to connect via bastion ssh"
  default     = {}
}
