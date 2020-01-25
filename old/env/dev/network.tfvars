aws_region = "eu-central-1"
vpc_cidr_block = "10.0.0.0/16"
bastion_host_public_key = "id_rsa.pub"

availability_zones = "eu-central-1a"
public_subnet_cidr_block = "10.0.0.0/24"
private_subnet_cidr_block  = "10.0.101.0/24"
isolated_subnet_cidr_block = "10.0.201.0/24"

#availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
#public_subnet_cidr_block = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
#private_subnet_cidr_block  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
#isolated_subnet_cidr_block = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]