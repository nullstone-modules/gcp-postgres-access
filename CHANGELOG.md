# 0.1.6 (Aug 28, 2026)
* `var.username` now supports `{{ NULLSTONE_STACK }}`, `{{ NULLSTONE_BLOCK }}`, and `{{ NULLSTONE_ENV }}` interpolation.
* `var.database_name` now resolves `{{ NULLSTONE_BLOCK }}` in addition to the existing `{{ NULLSTONE_APP }}`.

# 0.1.5 (Aug 20, 2026)
* Added `var.username` to override the generated Postgres role name. 

# 0.1.4 (Aug 03, 2026)
* Removed `settable_parameters`.

# 0.1.3 (Aug 03, 2026)
* Added `settable_parameters`, granting the app role `SET` on postgres configuration parameters that otherwise require a superuser context, such as `session_replication_role`.
  Restricted to an allowlist of session-scoped parameters; anything that can load code or bypass data integrity checks is excluded.
  Empty by default, which grants nothing. Requires postgres 15+ and pg-db-admin 0.9.3+.

# 0.1.2 (Jul 30, 2026)
* Read the managed superuser role from the datastore's `db_superuser_role` output instead of hardcoding `cloudsqlsuperuser`. This allows this capability to be used with AlloyDB (`alloydbsuperuser`). Falls back to `cloudsqlsuperuser` for datastore modules that do not publish the output.

# 0.1.1 (May 20, 2026)
* Added `var.post_app_metadata`.

# 0.1.0 (Apr 30, 2026)
* Initial release
