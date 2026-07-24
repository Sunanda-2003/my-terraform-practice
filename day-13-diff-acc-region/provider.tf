# # Account 1 - Mumbai
# provider "aws" {
#   alias   = "dev"
#   region  = "ap-south-1"
#   profile = "dev-account"
# }

# # Account 2 - Virginia
# provider "aws" {
#   alias   = "prod"
#   region  = "us-east-1"
#   profile = "prod-account"
# }

provider "aws" {
  alias      = "sunanda"
  region     = "ap-south-1"
  access_key = var.sunanda_access_key
  secret_key = var.sunanda_secret_key
}

provider "aws" {
  alias      = "karumuri"
  region     = "us-east-1"
  access_key = var.karumuri_access_key
  secret_key = var.karumuri_secret_key
}