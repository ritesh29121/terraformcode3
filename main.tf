# EC2 Instances
resource "aws_instance" "web" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  count           = 2
  key_name        = aws_key_pair.TF_key.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name          = "my_ec2_machines"
    creation_Date = "29/07/2024"
    Owner         = "Ritesh"
  }
}


# Elastic IPs
resource "aws_eip" "lb" {
  count    = 2
  instance = aws_instance.web[count.index].id
  domain   = "vpc"

  tags = {
    Name = "ElasticIp"
  }
}

# Key Pair Generation
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "TF_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${path.module}/files/tfkey.pem"
}



//Security_group

# Security Group
resource "aws_security_group" "allow_tls" {
  name        = "iaac-sg-test"
  description = "Allow 80, 443, 22, and 8080 inbound traffic"

  ingress {
    description = "Allow HTTPS (443) inbound traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP (80) inbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH (22) inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow custom application (8080) inbound traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SecurityGroup"
  }
}

