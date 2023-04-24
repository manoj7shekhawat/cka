location = "North Europe"

resource_groups = {
  "backend" = {
    name = "core"
  }
}

storage = {
  name             = "mshekhawat"
  tier             = "Standard"
  replication_type = "RAGRS"
  container_type   = "private"
  container_names  = ["cks-tf"]
}

tags = {
  environment = "cks"
}