output "state_bucket" {
  description = ""
  value       = module.bootstrap.state_bucket
}

output "dynamodb_table_name" {
  description = ""
  value       = module.bootstrap.dynamodb_table
}
