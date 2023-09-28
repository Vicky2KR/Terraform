terraform{
    required_providers{
        aws = {
             source  = "hashicorp/aws"
             version = "~> 5.0"
        }
    }

provider "aws" {
  region     = "us-east-1"
  access_key = var.a_key
  secret_key = var.s_key
} 
