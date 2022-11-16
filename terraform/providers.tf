provider "aws" {
  region     = var.aws_region
  profile    = var.aws_profile
  default_tags {
    tags = {
      Name ="cf-demo-deployment"
      Environment = "code-challenge"
      Terraform = true
    }
  }
}
