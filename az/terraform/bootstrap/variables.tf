variable "resource_groups" {
  type = map(object({
    name = string
  }))
}

variable location {
  type = string
}

variable "storage" {
  type = object({
    name             = string
    tier             = string
    replication_type = string
    container_type   = string
    container_names  = list(string)
  })
}


# TAGS
variable "tags" {
  type = object({
    environment            = string
  })
}