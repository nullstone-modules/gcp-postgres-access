# 0.1.2 (Jul 30, 2026)
* Read the managed superuser role from the datastore's `db_superuser_role` output instead of hardcoding `cloudsqlsuperuser`. This allows this capability to be used with AlloyDB (`alloydbsuperuser`). Falls back to `cloudsqlsuperuser` for datastore modules that do not publish the output.

# 0.1.1 (May 20, 2026)
* Added `var.post_app_metadata`.

# 0.1.0 (Apr 30, 2026)
* Initial release
