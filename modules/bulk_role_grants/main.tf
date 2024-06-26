terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.88.0"
    }
    random = {
      version = ">=2.2.0"
    }
  }
#  experiments = [module_variable_optional_attrs]
}

resource "snowflake_role_grants" "main" {
  for_each = var.grants

  role_name = coalesce(each.value["role_name"], each.key)
  roles     = coalesce(each.value["roles"], var.default_roles)
  users     = coalesce(each.value["users"], var.default_users)
}
