variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable "database_name" {
  type        = string
  description = "Name of database to create in PostgreSQL cluster. If left blank, uses app name."
  default     = ""
}

locals {
  username       = local.resource_name
  database_name  = coalesce(var.database_name, local.block_name)
  database_owner = local.database_name
}
