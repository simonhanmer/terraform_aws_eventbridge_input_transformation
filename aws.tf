provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project = "S3 Eventbridge input transforer"
      Repo    = "terraform_aws_eventbridge_input_transformation"
    }
  }
}

terraform {
  backend "s3" {
    key            = "eventbridge_transformer.tfstate"
    dynamodb_table = "terraform-lock-table"
    region         = "eu-west-1"
  }
}