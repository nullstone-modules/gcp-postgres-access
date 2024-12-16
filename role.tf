resource "restapi_object" "role" {
  path         = "/roles"
  id_attribute = "name"
  object_id    = local.username
  force_new    = [local.username]
  destroy_path = "/skip"

  data = jsonencode({
    name        = local.username
    password    = random_password.this.result
    useExisting = true
  })
}

resource "restapi_object" "role_member" {
  path         = "/roles/${local.database_owner}/members"
  id_attribute = "member"
  object_id    = "${local.database_owner}::${local.username}"
  force_new    = [local.database_owner, local.username]
  destroy_path = "/skip"

  data = jsonencode({
    target      = local.database_owner
    member      = local.username
    useExisting = true
  })

  depends_on = [
    restapi_object.database_owner,
    restapi_object.role
  ]
}

resource "restapi_object" "schema_privileges" {
  path         = "/databases/${local.database_name}/schema_privileges"
  id_attribute = "role"
  object_id    = "${local.database_name}::${local.username}"
  force_new    = [local.database_name, local.username]
  destroy_path = "/skip"

  data = jsonencode({
    database = local.database_name
    role     = local.username
  })

  depends_on = [
    restapi_object.database,
    restapi_object.role
  ]
}

resource "restapi_object" "default_grants" {
  path         = "/roles/${local.username}/default_grants"
  id_attribute = "id"
  object_id    = "${local.username}::${local.database_owner}::${local.database_name}"
  force_new    = [local.username, local.database_owner, local.database_name]
  destroy_path = "/skip"

  data = jsonencode({
    role     = local.username
    target   = local.database_owner
    database = local.database_name
  })

  depends_on = [
    restapi_object.role,
    restapi_object.database,
    restapi_object.database_owner
  ]
}

resource "restapi_object" "cloudsqlsuperuser" {
  path         = "/roles/${local.username}/cloudsqlsuperuser"
  id_attribute = "id"
  object_id    = "${local.username}::${local.database_owner}::${local.database_name}"
  force_new    = [local.username, local.database_owner, local.database_name]
  destroy_path = "/skip"

  data = jsonencode({
    role     = local.username
    target   = local.database_owner
    database = local.database_name
  })

  depends_on = [
    restapi_object.role,
    restapi_object.database,
    restapi_object.database_owner
  ]
}
