terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }

  # The s3 state backend is already set up under `exosite-temporary-tfstate`
  backend "s3" {
    bucket         = "exosite-temporary-tfstate"
    key            = "tchouetckeatankoua/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "tflock"
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      "Owner" = "tchouetckeatankoua"
    }
  }
}

# Some useful values from the environment
locals {
  resource_name_prefix = "tcta_"
  vpc_id = "vpc-0c2a36846ba20e729"
  subnet_ids = [
    "subnet-0068679226e81966f",
    "subnet-0db7119e20b440c97",
    "subnet-056f4097e702e48ac",
    "subnet-07c4289662cca87e6",

  ]
  domain_name = "tchouetckeatankoua.interview.exosite.biz"
  zone_id     = "Z0900350IRBV4VB1AT02"
} 
