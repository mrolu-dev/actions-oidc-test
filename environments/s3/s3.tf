module "s3call_ssh" {
  source = "git@github.com:ristabel/tickets.git//s3-module?ref=v1.1.0"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "laflortfstate"
    key     = "s3/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
provider "aws" {
  region = "us-west-2"

}
