resource "aws_instance" "name" {
    ami = "ami-01edba92f9036f76e"
    instance_type = "t3.micro"
    count = length(var.tags)
    tags = {
        Name = var.tags[count.index]
    }
  
}