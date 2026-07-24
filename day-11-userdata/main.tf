resource "aws_instance" "name" {
    ami = "ami-01edba92f9036f76e"
    instance_type = "t3.micro"
    user_data = file("userdata.sh")
    tags = {
        Name = "sri"
    }
  
}