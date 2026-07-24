# main.tf
resource "aws_security_group" "devops-project-suprabha" {
  name        = "devops-project-suprabha-VPC"
  description = "Allow inbound traffic"

  # Dynamic ingress — CIDR se port map hoga
  dynamic "ingress" {
    for_each = flatten([
      for cidr, ports in var.cidr_port_map : [
        for port in ports : {
          cidr = cidr
          port = port
        }
      ]
    ])

    content {
      description      = "inbound rule for ${ingress.value.cidr}"
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = "tcp"
      cidr_blocks      = [ingress.value.cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dynamic-sg"
  }
}