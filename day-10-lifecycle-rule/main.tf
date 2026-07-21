resource "aws_instance" "name" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"

  tags = {
    Name = "server1"
  }
  #lifecycle {
   # create_before_destroy = true
  #}
  #lifecycle {
   # ignore_changes = [ tags ]
  #}
  #lifecycle {
   # prevent_destroy = true
  #}
}



