resource "aws_instance" "name" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.small"

  tags = {
    Name = "server1"
  }
}

resource "aws_s3_bucket" "name" {
    bucket = "jghbfjhgvb"
  
}

resource "aws_s3_bucket_versioning" "example_versioning" {
    bucket = aws_s3_bucket.name.id
    versioning_configuration {
      status = "Enabled"
    }
  
}