variable "resource_label" {
  type = string
}

variable "location" {
  type    = string
  default = "Korea Central"
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "db_host" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "virtual_network_id" {
  type = string
}