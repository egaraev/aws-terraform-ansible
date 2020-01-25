#variable "aws_region" {
#  description = "Region for the VPC"
#  default  = "${var.aws_region}"
#}

variable "aws_region"  {}
variable "vpc_cidr_block"  {}
#variable "availability_zones" {}
#variable "public_subnet_cidr_block" {}
#variable "private_subnet_cidr_block" {}
#variable "isolated_subnet_cidr_block" {}

variable "counts" {
  default = 3
}



#variable "vpc_cidr" {
#  description = "CIDR for the VPC"
#  default = "10.0.0.0/16"
#}

#variable "public_subnet_cidr" {
#  description = "CIDR for the public subnet"
#  default = "10.0.1.0/24"
#}

#variable "private_subnet_cidr" {
#  description = "CIDR for the private subnet"
#  default = "10.0.2.0/24"
#}



variable "availability_zones" {
#   type = "list"
   description = "AWS Region Availability Zones"
}
variable "public_subnet_cidr_block" {
#   type = "list"
   description = "Public Subnet CIDR Block"
}

variable "private_subnet_cidr_block" {
#   type = "list"
   description = "Private Subnet CIDR Block"
}

variable "isolated_subnet_cidr_block" {
#   type = "list"  
   description = "Isolated Subnet CIDR Block"
}


variable "rhel_ami" {
  description = "RHEL AMI"
  default = "ami-c86c3f23"
}


variable "aws_ami" {
  description = "Amazon AMI"
  default = "ami-0cfbf4f6db41068ac"
}


variable "key_path" {
  description = "SSH Public Key path"
  default = "id_rsa.pub"
}


variable "bastion_host_public_key" {
   description = "Bastion host public key"
}

variable "web_bootstrap_path" {
  description = "Script to install SW"
  default = "install_web.sh"
}

variable "db_bootstrap_path" {
  description = "Script to install DB SW"
  default = "install_db.sh"
}

variable "nfs_bootstrap_path" {
  description = "Script to setup NFS server"
  default = "install_nfs.sh"
}

