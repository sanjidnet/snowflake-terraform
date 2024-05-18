provider "snowflake" {
  account  = var.snowflake_account
  username = var.snowflake_username
  password = var.snowflake_user_password
  role     = var.snowflake_user_role
}
