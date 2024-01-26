terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.aws_vpc.cidr_block
  enable_dns_support   = var.aws_vpc.enable_dns_support
  enable_dns_hostnames = var.aws_vpc.enable_dns_hostnames
  tags = {
    Name = var.aws_vpc.name
  }
}

# public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet.cidr_block
  availability_zone       = var.public_subnet.availability_zone
  map_public_ip_on_launch = var.public_subnet.map_public_ip_on_launch

  tags = {
    Name = var.public_subnet.name
  }
}

# private subnet
resource "aws_subnet" "private_subnets" {
  count              = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = var.private_subnets[count.index].availability_zone
  
  tags = {
    Name = "cog-dev-a-private-subnet-${count.index + 1}"
  }
}


# DocumentDB subnet group
resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name        = var.docdb_subnet_group.name
  description = var.docdb_subnet_group.description
  subnet_ids  = flatten([for subnet in aws_subnet.private_subnets : subnet.id])
  }

# DocumentDB parameter group
resource "aws_docdb_cluster_parameter_group" "docdb_cluster_parameter_group" {
  family      = var.docdb_cluster_parameter_group.family
  name        = var.docdb_cluster_parameter_group.name
  description = var.docdb_cluster_parameter_group.description

  parameter {
    name  = "tls"
    value = "enabled"
  }
}

# DocumentDB cluster instance
resource "aws_docdb_cluster_instance" "cluster_instances" {
  identifier         = var.cluster_instances.identifier
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = var.cluster_instances.instance_class
  engine             = var.cluster_instances.engine
}

# DocumentDB cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier     = var.docdb_cluster.cluster_identifier
  engine_version         = var.docdb_cluster.engine_version
  master_username        = var.docdb_cluster.master_username
  master_password        = var.docdb_cluster.master_password
  db_subnet_group_name   = aws_docdb_subnet_group.docdb_subnet_group.name
  availability_zones     = var.docdb_cluster.availability_zones
  skip_final_snapshot    = var.docdb_cluster.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.docdb_security_group.id]
  deletion_protection    = false
}



# security group for DocumentDB
resource "aws_security_group" "docdb_security_group" {
  name        = var.docdb_security_group.name
  description = var.docdb_security_group.description
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.private_subnets

    content {
      from_port   = var.docdb_security_group.from_port
      to_port     = var.docdb_security_group.to_port
      protocol    = var.docdb_security_group.protocol
      cidr_blocks = [ingress.value.cidr_block]
    }
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }


# resource "aws_instance" "bastion_host" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.micro"  
#   key_name               = "cog-dev-a-bastion-host-1"  
#   subnet_id              = aws_subnet.private_subnets[0].id  
#   associate_public_ip    = false  
#   security_groups        = aws_security_group.bastion_security_group.id
#   tags = {
#     Name = "cog-dev-a-bastion-host"
#   }
# }

# resource "aws_security_group" "bastion_security_group" {
#   name        = "cog-dev-a-bastion-security-group"
#   description = "Security group for the bastion host"
#   vpc_id      = aws_vpc.my_vpc.id

#   dynamic "ingress" {
#     for_each = [22, 80, 443]

#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "cog-dev-a-bastion-security-group"
#   }
# }

