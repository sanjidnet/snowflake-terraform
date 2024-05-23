locals {
  public_role   = "PUBLIC"
  sysadmin_role = "SYSADMIN"
  employees = {
    "richard" = {
      name       = "Richard Hendricks"
      login_name = "richard_hendricks"
    }
    "gilfoyle" = {
      login_name = "gilfoyle"
      email      = "gifoyle@piedpiper.lol"
    }
    "elrich" = {
      login_name = "elrich"
      email      = "elrich@piedpiper.lol"
    }
  }
  system_users = {
    "LOOKER_USER"    = {}
    "SUPERSET_USER"  = {}
    "IMMUTA_USER"    = {}
    "HIGHTOUCH_USER" = {}
    "DBT_CLOUD_USER" = {
      default_role = module.bulk_roles.roles["DBT_CLOUD"].name
    }
  }
}
