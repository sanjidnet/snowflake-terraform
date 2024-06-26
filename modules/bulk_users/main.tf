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

locals {
  users_requiring_password = [
    for k, v in var.users : k if coalesce(v.generate_user_password, var.default_generate_user_password)
  ]
}


resource "snowflake_user" "main" {
  for_each = var.users

  name         = coalesce(each.value["name"], each.key)
  email        = coalesce(each.value["email"], "${each.key}@fsoft.com.vn.test")
  first_name   = each.value["first_name"]
  last_name    = each.value["last_name"]
  login_name   = each.value["login_name"]
  display_name = each.value["display_name"]

  #  password             = coalesce(each.value["generate_user_password"], var.default_generate_user_password) ? random_password.users[each.key].result : null
  password             = each.value["login_name"]
  must_change_password = coalesce(each.value["must_change_password"], var.default_must_change_password)

  comment           = try(coalesce(each.value["comment"], var.default_comment), null)
  default_role      = try(coalesce(each.value["default_role"], var.default_role), null)
  default_namespace = try(coalesce(each.value["default_namespace"], var.default_namespace), null)
  default_warehouse = try(coalesce(each.value["default_warehouse"], var.default_warehouse), null)

  depends_on = [random_password.users]
  lifecycle {
    ignore_changes = [
      password,
      must_change_password
    ]
  }
}

resource "random_password" "users" {
  for_each = toset(local.users_requiring_password)

  length  = 16
  special = false
}
