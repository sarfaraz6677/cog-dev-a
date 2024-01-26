variable "aws_vpc" {
  type = object({
    cidr_block           = string,
    enable_dns_support   = string,
    enable_dns_hostnames = string,
    name                 = string
  })
}

variable "public_subnet" {
  type = object({
    cidr_block              = string,
    availability_zone       = string,
    map_public_ip_on_launch = string,
    name                    = string
  })
}

variable "private_subnets" {
  default = [
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1c"
    },
  ]
}


variable "docdb_subnet_group" {
  type = object({
    name        = string,
    description = string
  })
}

variable "docdb_cluster_parameter_group" {
  type        = object({
    family = string,
    name = string,
    description = string
  })
}

variable "cluster_instances" {
  type        = object({
    identifier  = string,
    instance_class = string,
    engine = string
  })
}


variable "docdb_cluster" {
  type = object({
    cluster_identifier  = string,
    engine_version      = string,
    master_username     = string,
    master_password     = string,
    availability_zones  = list(string),
    skip_final_snapshot = string
  })
}

variable "docdb_security_group" {
  type = object({
    name        = string,
    description = string,
    from_port   = string,
    to_port     = string,
    protocol    = string
  })
}
