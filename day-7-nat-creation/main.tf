resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true     
  enable_dns_hostnames = true 
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
    availability_zone = "us-east-1a"
    cidr_block = "10.0.2.0/24"   
    tags = {     
        name = "sri-subnet" 
  } 
} 

resource "aws_subnet" "sri_subnet_pri2" {   
    vpc_id = aws_vpc.vpc.id   
    availability_zone = "us-east-1b"
    cidr_block = "10.0.3.0/24"   
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

resource "aws_db_subnet_group" "db_subnet_group" {
tags = {
  Name = "db-sg"
}
subnet_ids = [aws_subnet.sri_subnet_pri.id, aws_subnet.sri_subnet_pri2.id]
}

# RDS MySQL Instance resource 
resource "aws_db_instance" "RDS" {
  tags = {
    Name = "rds"
  }
  engine = "mysql"   
  allocated_storage = 20
  engine_version = "8.0"
  instance_class        = "db.t3.micro"   
  max_allocated_storage = 100   
  storage_type          = "gp2"  
  username = "admin"
  password = "Admin123"
  port = 3306 
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name 
  vpc_security_group_ids = [   aws_security_group.sri_sg.id] 
 
  publicly_accessible = false   
  multi_az            = false 
  backup_retention_period = 1
  skip_final_snapshot = true   
  deletion_protection = false 
} 
resource "aws_db_instance" "replica" {
  identifier = "mydb-read-replica"
  instance_class = "db.t3.micro"
  replicate_source_db = aws_db_instance.RDS.identifier
  vpc_security_group_ids = [aws_security_group.sri_sg.id]
  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately = true
   
  }


  resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name = "elasticache-subnet-group"

  subnet_ids = [
    aws_subnet.sri_subnet_pri.id,
    aws_subnet.sri_subnet_pri2.id
  ]

  tags = {
    Name = "elasticache-subnet-group"
  }
}
resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.sri_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_elasticache_replication_group" "elasticache" {
  tags = {
    Name = "custom-redis"
  }
  replication_group_id = "custom-redis"
  description = "Redis cache for application"
  engine         = "redis"
  engine_version = "7.1"
  node_type = "cache.t3.micro"
  port = 6379
  num_cache_clusters = 1
  subnet_group_name = aws_elasticache_subnet_group.elasticache_subnet_group.name
  security_group_ids = [   aws_security_group.sri_sg.id] 
  automatic_failover_enabled = false
  
  
}