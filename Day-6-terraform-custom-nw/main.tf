resource "aws_vpc" "sri_vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "sri"
  }
}

resource "aws_subnet" "sri_subnet" {
  vpc_id = aws_vpc.sri_vpc1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    name = "sri-subnet"
  }
}

resource "aws_internet_gateway" "sri_igw" {
  vpc_id = aws_vpc.sri_vpc1.id
  tags = {
    Name = "sri-ig"
  }
}

