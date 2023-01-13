provider "snowflake" {
  account  = var.snowflake_account
  region   = var.snowflake_region
  username = var.snowflake_username
  password = var.snowflake_user_password
  role     = var.snowflake_user_role
}

locals {
  developer_list = ["harry", "hermione"]
}

module "employees" {
  source = "./modules/bulk_users"
  users = {
    "dba" = {}
    "loader" = {}
    "transformer" = {}
    "bi-tools" = {}
    "analysts" = {}
  }

  default_role                   = "PUBLIC"
  default_generate_user_password = true
}

module "bulk_roles" {
  source = "./modules/bulk_roles"
  roles = {
    loader = { name = "LOADER_ROLE" }
    transformer = { name = "TRANSFORMER_ROLE" }
    reporter = { name = "REPORTER_ROLE" }
  }
}

module "bulk_warehouses" {
  source = "./modules/bulk_warehouses"
  warehouses = {
    loading = {
      name                    = "LOADING_WH"
    }
    transform = {
      name                    = "TRANSFORM_WH"
      create_resource_monitor = true
    }
    report = {
      name = "REPORTING_WH"
    }
  }
  default_size    = "x-small"
  default_comment = "3 warehouses."
}

// role and warehouse grants
module "bulk_role_grants" {
  source = "./modules/bulk_role_grants"
  grants = {
    dba = {
      role_name = "ACCOUNTADMIN"
      users     = [module.employees.users["dba"].name]
    }
    loader = {
      role_name = module.bulk_roles.roles["loader"].name
      users     = [module.employees.users["loader"].name]
    }
    transform = {
      role_name = module.bulk_roles.roles["transformer"].name
      users     = [module.employees.users["transformer"].name]
    }
    bi-tools = {
      role_name = module.bulk_roles.roles["reporter"].name
      users     = [module.employees.users["bi-tools"].name]
    }
    analysts = {
      role_name = module.bulk_roles.roles["transformer"].name
      users     = [module.employees.users["analysts"].name]
    }

  }
}

module "bulk_warehouse_grants" {
  source = "./modules/bulk_warehouse_grants"
  grants = {
    loading = {
      warehouse_name = module.bulk_warehouses.warehouses["loading"].name
      roles          = [module.bulk_roles.roles["loader"].name]
    }
    transform = {
      warehouse_name = module.bulk_warehouses.warehouses["transform"].name
      roles          = [module.bulk_roles.roles["transformer"].name]
    }
    report = {
      warehouse_name = module.bulk_warehouses.warehouses["report"].name
      roles          = [module.bulk_roles.roles["reporter"].name, module.bulk_roles.roles["transformer"].name]
    }
  }
}

// databases
module "raw_db" {
  source = "./modules/application_database"

  database_name        = "raw"
  grant_admin_to_roles = []
  grant_admin_to_users = [module.employees.users["dba"].name]
  grant_read_to_roles  = [module.bulk_roles.roles["reporter"].name]
}

#module "developer_dbs" {
#  for_each = toset(local.developer_list)
#  source   = "./modules/application_database"
#
#  database_name                = "DEV_${module.employees.users[each.key].name}"
#  admin_role_name_suffix       = ""
#  create_application_user      = false
#  create_application_warehouse = false
#  grant_admin_to_users         = [module.employees.users[each.key].name]
#}
