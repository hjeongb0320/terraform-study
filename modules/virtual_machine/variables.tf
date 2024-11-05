variable "resource_label" {
  type = string
}

variable "location" {
  type        = string
  description = "cloud region (default: Korea Central)"
  default     = "Korea Central"
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}