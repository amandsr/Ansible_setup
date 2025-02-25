terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region                   = "us-east-1"
  #shared_credentials_files = ["~/.aws/credentials"]
  #profile                  = "dev"
}

terraform {
  backend "s3" {
    bucket = "s3backend-gha"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true  # Optional: Encrypt the state file in S3
  }
}
