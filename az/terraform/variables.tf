variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "network" {
  type        = any
  description = "Input object for network."
}

variable "compute" {
  type        = any
  description = "Input object for compute resources."
}

variable "admin_password" {
  type = string
  default   = "Welcome@123"
  nullable  = false
  sensitive = true
}

# TAGS
variable "tags" {
  type = object({
    environment            = string
  })
}