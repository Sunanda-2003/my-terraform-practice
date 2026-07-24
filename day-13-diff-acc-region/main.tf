# EC2 in Dev Account (Mumbai)

resource "aws_instance" "sunanda_ec2" {
  provider = aws.sunanda

  ami           = "ami-09d88f7c4c272b0c5"
  instance_type = "t3.micro"

  tags = {
    Name = "sunanda-Server"
  }
}

# EC2 in Prod Account (Virginia)

resource "aws_instance" "karumuri_ec2" {
  provider = aws.karumuri

  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"

  tags = {
    Name = "karumuri-Server"
  }
}