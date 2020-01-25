## CREATE VPC

# Define our VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "my-terraform-aws-vpc-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

###############################################################
## CREATE SUBNETS
# Define the public subnet

resource "aws_subnet" "public_subnet" {
  #count      = "${length(var.public_subnet_cidr_block)}"
  vpc_id     = "${aws_vpc.main.id}"
  #cidr_block = "${element(var.public_subnet_cidr_block, count.index)}"
  #availability_zone = "${element(var.availability_zones, count.index)}"
 
  cidr_block = "${var.public_subnet_cidr_block}"
  availability_zone = "${var.availability_zones}"


  tags {
#    Name = "public_subnet_${count.index}"
    Name = "public_subnet_1"
  }
}


resource "aws_subnet" "private_subnet" {
#  count      = "${length(var.private_subnet_cidr_block)}"
  vpc_id     = "${aws_vpc.main.id}"
#  cidr_block = "${element(var.private_subnet_cidr_block, count.index)}"
#  availability_zone = "${element(var.availability_zones, count.index)}"

  cidr_block = "${var.private_subnet_cidr_block}"
  availability_zone = "${var.availability_zones}"

  tags {
#    Name = "private_subnet_${count.index}"
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "isolated_subnet" {
#  count      = "${length(var.isolated_subnet_cidr_block)}"
  vpc_id     = "${aws_vpc.main.id}"
#  cidr_block = "${element(var.isolated_subnet_cidr_block, count.index)}"
#  availability_zone = "${element(var.availability_zones, count.index)}"

  cidr_block = "${var.isolated_subnet_cidr_block}"
  availability_zone = "${var.availability_zones}"


  tags {
#    Name = "isolated_subnet_${count.index}"
    Name = "isolated_subnet_1"
  }
}




#############################################################
## CREATE INTERNET GATEWAYS

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
}

# EIP and NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 1)}"

  depends_on = ["aws_internet_gateway.igw"]
}

