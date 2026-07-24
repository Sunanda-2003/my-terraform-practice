terraform {
  backend "s3" {
    bucket = "dfjhgildsuhgkjv"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    dynamodb_table = "terraform-state-locking"
  }
}