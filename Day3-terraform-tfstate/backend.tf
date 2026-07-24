terraform {
  backend "s3" {
    bucket = "muhrjhgkjfdgbksg"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
