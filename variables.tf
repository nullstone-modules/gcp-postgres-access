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

variable "settable_parameters" {
  type        = list(string)
  default     = []
  description = <<EOF
Postgres configuration parameters that the app role is allowed to change with `SET`.
See https://www.postgresql.org/docs/current/runtime-config.html for what each parameter does.

Some parameters require a superuser context, so the app role is refused by default. The common one is
`session_replication_role`, which a bulk load sets to `replica` to disable foreign key triggers.
Membership in `cloudsqlsuperuser` is not enough on its own, because postgres never inherits role
attributes through membership.

Allowed values, grouped by their page under https://www.postgresql.org/docs/current/:

  Client Connection Defaults -- runtime-config-client.html
    session_replication_role    Set to `replica` to disable foreign key triggers during a bulk load.
                                Postgres warns this can leave data inconsistent if misused.

  Error Reporting and Logging -- runtime-config-logging.html
    log_statement, log_duration, log_error_verbosity, log_lock_waits, log_temp_files,
    log_min_messages, log_min_error_statement, log_min_duration_statement

  Lock Management -- runtime-config-locks.html
    deadlock_timeout

  Resource Consumption -- runtime-config-resource.html
    temp_file_limit

  Run-time Statistics -- runtime-config-statistics.html
    track_io_timing

Parameters that can load code (`session_preload_libraries`, `dynamic_library_path`) or bypass data
integrity checks (`zero_damaged_pages`, `ignore_checksum_failure`, `allow_system_table_mods`) are
deliberately excluded.

Leave empty to grant nothing. Requires postgres 15+ and pg-db-admin 0.9.3+.
EOF

  validation {
    // Terraform 1.5 only lets a validation condition refer to the variable itself, so this list cannot
    // live in a local. Keep it in sync with the description above.
    condition = alltrue([for parameter in var.settable_parameters : contains([
      "session_replication_role",
      "deadlock_timeout",
      "temp_file_limit",
      "track_io_timing",
      "log_statement",
      "log_duration",
      "log_error_verbosity",
      "log_lock_waits",
      "log_temp_files",
      "log_min_messages",
      "log_min_error_statement",
      "log_min_duration_statement",
    ], parameter)])
    error_message = "settable_parameters may only contain: session_replication_role, deadlock_timeout, temp_file_limit, track_io_timing, log_statement, log_duration, log_error_verbosity, log_lock_waits, log_temp_files, log_min_messages, log_min_error_statement, log_min_duration_statement."
  }
}

variable "strict_password_policy" {
  type        = bool
  default     = true
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
