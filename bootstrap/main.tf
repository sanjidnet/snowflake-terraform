module "bootstrap" {
  source = "trussworks/bootstrap/aws"

  region               = var.aws_region
  account_alias        = var.account_alias
  dynamodb_table_name  = var.dynamodb_table_name
  manage_account_alias = false
}
