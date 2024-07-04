locals {
  public_role   = "PUBLIC"
  sysadmin_role = "SYSADMIN"
  employees = {
    "richard" = {
      name       = "Richard Hendricks"
      login_name = "richard_hendricks"
      email      = "richard@piedpiper.lol"
    }
    "big_head" = {
      login_name = "big_head"
      email      = "big@piedpiper.lol"
    }
    "levy_levin" = {
      login_name = "levy"
      email      = "levy@piedpiper.lol"
    }
  }
  system_users = {
    "LOOKER_USER"   = {}
    "SUPERSET_USER" = {}
    "DBT_CLOUD_USER" = {
      default_role = module.bulk_roles.roles["DBT_CLOUD"].name
    }
  }
}
