resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "sri"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "my-igw"
  }
}


resource "aws_subnet" "sri_subnet_pri" {   
    vpc_id = aws_vpc.vpc.id   
    cidr_block = "10.0.2.0/24"   
    tags = {     
        name = "sri-subnet" 
  } 
} 
 

 
resource "aws_nat_gateway" "regional_nat" {
  vpc_id = aws_vpc.vpc.id
  availability_mode = "regional"
  tags = {
    name = "regional-nat-gateway"
  }
}

 
resource "aws_route_table" "private_rt" {   
    vpc_id = aws_vpc.vpc.id 
 
  tags = { 
    Name = "private-route-table" 
  } 
  route {     
    cidr_block = "0.0.0.0/0"     
    nat_gateway_id = aws_nat_gateway.regional_nat.id 
  }   
} 
 
resource "aws_route_table_association" "sri_priroute_table_assosiation" {   
    subnet_id = aws_subnet.sri_subnet_pri.id   
    route_table_id = aws_route_table.private_rt.id 
} 

resource "aws_security_group" "sri_sg" {   
    vpc_id = aws_vpc.vpc.id 
    name = "sri-security-group" 
 
  ingress {     
    from_port = 22     
    to_port = 22     
    protocol = "tcp"     
    cidr_blocks = ["0.0.0.0/0"] 
 
  } 
  ingress {     
    from_port = 0     
    to_port = 0     
    protocol = "-1"     
    cidr_blocks = ["0.0.0.0/0"] 
 
  } 

} 

 
resource "aws_instance" "sri_priinstance" {  
    ami = "ami-01edba92f9036f76e"  
    instance_type = "t3.micro" 
    subnet_id = aws_subnet.sri_subnet_pri.id 
    associate_public_ip_address = false 
    vpc_security_group_ids = [aws_security_group.sri_sg.id] 
    tags = { 
  Name = "sri-instance" 
}
 
}
