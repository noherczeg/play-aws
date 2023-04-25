terraform {
  backend "s3" {
    bucket         = "play-aws-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "play-aws-terraform-lock"
  }
}
