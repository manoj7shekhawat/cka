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

# TAGS
variable "tags" {
  type = object({
    environment            = string
  })
}