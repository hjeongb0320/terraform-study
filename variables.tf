variable "subscription_id" {
  description = "resource's target subscription id"
  type        = string
  sensitive   = true
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type      = string
  sensitive = true
}

variable "resource_label" {
  description = "label for making resource's unique name"
  type        = string
}

variable "location" {
  description = "cloud region (default: Korea Central)"
  type        = string
  default     = "Korea Central"
}

variable "db_host" {
  description = "The admin name for the dateabase"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The admin password for the dateabase"
  type        = string
  sensitive   = true
}