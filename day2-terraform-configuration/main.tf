resource "aws_vpc" "sunanda" {
  cidr_block = var.cidr_block
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_vpc" "sri" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.sunanda.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-subnet"
  }
}