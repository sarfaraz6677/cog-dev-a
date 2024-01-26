aws_vpc = {
  "cidr_block" : "10.0.0.0/16"
  "enable_dns_support" : "true"
  "enable_dns_hostnames" : "true"
  "name" : "cog-dev-a-vpc"
}

public_subnet = {
  "cidr_block" : "10.0.1.0/24"
  "availability_zone" : "us-east-1a"
  "map_public_ip_on_launch" : "true"
  "name" : "cog-dev-a-public-subnet"
}


docdb_subnet_group = {
  "name" : "cog-dev-a-docdb-subnet-group"
  "description" : "Testing Purpose COG-Project"
}


docdb_cluster_parameter_group = {
  "family"     : "docdb5.0"
  "name"       : "cog-dev-a-docdb-cluster-parameter-group"
  "description" : "docdb cluster parameter group"

}

cluster_instances = {
  "identifier" = "cog-dev-a-docdb-cluster-instance"
  "instance_class" = "db.t3.medium"
  "engine" = "docdb"
}
docdb_cluster = {
  "cluster_identifier" : "cog-dev-a-docdb-cluster"
  "engine_version" : "4.0.0"
  "master_username" : "testuser"
  "master_password" : "test1234"
  "availability_zones" : ["us-east-1b"]
  "skip_final_snapshot" : "true"
}

docdb_security_group = {
  "name" : "cog-dev-a-docdb-security-group"
  "description" : "Security Group for DocumentDB"
  "from_port" : "27017"
  "to_port" : "27017"
  "protocol" : "tcp"
}