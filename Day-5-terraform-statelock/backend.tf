terraform {
  backend "s3" {
    bucket = "dfjhgildsuhgkjv"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}