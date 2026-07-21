data "aws_subnet" "name" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"]
  }
}


resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.name.id
}