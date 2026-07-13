terraform {
  backend "s3" {
    bucket = "gfjmnjhglkhb"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}