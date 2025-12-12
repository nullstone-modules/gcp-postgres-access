provider "google" {
  alias                       = "invoker"
  impersonate_service_account = local.db_admin_invoker.email
}

data "google_service_account_id_token" "invoker" {
  target_audience = coalesce(local.db_admin_func_url, "https://missing-db-admin-url")
  provider        = google.invoker
}

provider "restapi" {
  uri                  = coalesce(local.db_admin_func_url, "https://missing-db-admin-url")
  write_returns_object = true

  headers = {
    "Authorization" : "Bearer ${data.google_service_account_id_token.invoker.id_token}"
  }
}
