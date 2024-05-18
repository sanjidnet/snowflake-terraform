terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.88.0"
    }
  }

  backend "s3" {
    profile        = "sanjid_mac"
    bucket         = "sanjidnet-tf-state-ap-southeast-2"
    key            = "bootstrap/terraform.tfstate"
    dynamodb_table = "dynamo"
    region         = "ap-southeast-2"
    encrypt        = "true"
  }
}
