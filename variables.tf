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

variable "strict_password_policy" {
  type        = bool
  default     = false
  description = "Enforce strict password policy which ensures there is one uppercase, one lowercase, one numeric, and one special character"
}

// We are using ns_env_variables to interpolate database_name
data "ns_env_variables" "db_name" {
  input_env_variables = tomap({
    NULLSTONE_STACK = local.stack_name
    NULLSTONE_APP   = local.block_name
    NULLSTONE_ENV   = local.env_name
    DATABASE_NAME   = coalesce(var.database_name, local.block_name)
  })
  input_secrets = tomap({})
}

locals {
  username       = local.resource_name
  database_name  = data.ns_env_variables.db_name.env_variables["DATABASE_NAME"]
  database_owner = replace(local.database_name, "postgres", "postgres_owner")
}
