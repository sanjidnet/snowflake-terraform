resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

output "test_random_string" {
  value = random_string.random.result
}
