
terraform {
  #   backend "s3" {
  #     bucket         = "toptal-project"
  #     key            = "toptal/vpc"
  #     region         = "us-east-1"
  #     profile        = "default"
  #     dynamodb_table = "terraform-lock"
  #   }

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

module "vpc" {
  source      = "../../modules"
  env         = "toptal"
  region      = "us-east-1"
  vpc-01-name = "project"
  vpc-01-cidr = "10.1.0.0/16"
}
