resource "restapi_object" "database_owner" {
  path         = "/roles"
  id_attribute = "name"
  object_id    = local.database_name
  force_new    = [local.database_name]
  destroy_path = "/skip"

  data = jsonencode({
    name        = local.database_owner
    useExisting = true
  })
}

resource "restapi_object" "database" {
  path         = "/databases"
  id_attribute = "name"
  object_id    = local.database_name
  force_new    = [local.database_name]
  destroy_path = "/skip"

  data = jsonencode({
    name        = local.database_name
    owner       = local.database_owner
    useExisting = true
  })

  depends_on = [restapi_object.database_owner]
}
