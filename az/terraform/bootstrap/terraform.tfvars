location = "North Europe"

resource_groups = {
  "backend" = {
    name = "core"
  }
}

storage = {
  name             = "mshekhawat"
  tier             = "Standard"
  replication_type = "RA-GRS"
  container_type   = "private"
  container_names  = ["cks_tf"]
}