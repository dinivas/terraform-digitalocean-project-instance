variable "enable_instance" {
  type    = "string"
  default = "1"
}

variable "project_name" {
  description = "The project this Instance belong to"
  type        = "string"
}

variable "instance_name" {
  description = "The name of the compute instance"
  type        = "string"
}

variable "instance_image_name" {
  description = "The Image name of the Instance"
  type        = "string"
}

variable "instance_flavor_name" {
  description = "The Flavor name of the Instance"
  type        = "string"
}

variable "instance_keypair_name" {
  description = "The Keypair name of the instance."
  type        = "string"
}

variable "instance_count" {
  type        = "string"
  description = "The number of instance."
  default = "1"
}

variable "instance_availability_zone" {
  description = "The availability zone"
  type        = "string"
}

variable "instance_network" {
  description = "The Network name of the instance"
  type        = "string"
}

variable "instance_subnet" {
  description = "The Network subnet name of the instance"
  type        = "string"
}

variable "instance_security_group_rules" {
  type        = list(map(any))
  default     = []
  description = "The definition os security groups to associate to instance. Only one is allowed"
}

variable "instance_security_groups_to_associate" {
  type        = list(string)
  default     = []
  description = "List of existing security groups to associate to instance."
}

variable "instance_metadata" {
  default = {}
}

# Project Consul variables

variable "project_consul_domain" {
  type        = "string"
  description = "The domain name to use for the Consul cluster"
}

variable "project_consul_datacenter" {
  type        = "string"
  description = "The datacenter name for the consul cluster"
}

# Auth variables used by consul

variable "os_auth_domain_name" {
  type    = "string"
  default = "default"
}

variable "os_auth_username" {
  type = "string"
}

variable "os_auth_password" {
  type = "string"
}

variable "os_auth_url" {
  type = "string"
}

variable "os_project_id" {
  type = "string"
}

variable "generic_user_data_file_url" {
  type    = "string"
  default = "https://raw.githubusercontent.com/dinivas/terraform-openstack-shared/master/templates/generic-user-data.tpl"
}

variable "execute_on_destroy_instance_script" {
  type    = "string"
  default = ""
}

variable "ssh_via_bastion_config" {
  description = "config map used to connect via bastion ssh"
  default     = {}
}
