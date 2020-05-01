provider "aws" {
   region = "eu-central-1"
}



resource "aws_key_pair" "root-ssh" {
   key_name = "root-ssh"
   public_key = file("/root/.ssh/id_rsa.pub")
}


data "aws_availability_zones" "available" {}

# Vpc resource
resource "aws_vpc" "myVpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = "${aws_vpc.myVpc.id}"

}

# Subnet (public)
resource "aws_subnet" "public_subnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.myVpc.id}"
  cidr_block              = "10.0.${10+count.index}.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

}

# Subnet (private)
resource "aws_subnet" "private_subnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.myVpc.id}"
  cidr_block              = "10.0.${20+count.index}.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false

}

# Routing table for public subnets
resource "aws_route_table" "rtblPublic" {
  vpc_id = "${aws_vpc.myVpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myInternetGateway.id}"
  }

}

resource "aws_route_table_association" "route" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rtblPublic.id}"
}

# Elastic IP for NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.private_subnet.*.id, 1)}"
  depends_on    = ["aws_internet_gateway.myInternetGateway"]
}

# Routing table for private subnets
resource "aws_route_table" "rtblPrivate" {
  vpc_id = "${aws_vpc.myVpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

}

resource "aws_route_table_association" "private_route" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rtblPrivate.id}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "instance_sg"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.myVpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our elb security group to access
# the ELB over HTTP
resource "aws_security_group" "elb" {
  name        = "elb_sg"
  description = "Used in the terraform"

  vpc_id = "${aws_vpc.myVpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ensure the VPC has an Internet gateway or this step will fail
  depends_on = ["aws_internet_gateway.myInternetGateway"]
}

resource "aws_elb" "web" {
  name = "example-elb"

  # The same availability zone as our instance
  subnets = ["${element(aws_subnet.public_subnet.*.id, 0)}", "${element(aws_subnet.public_subnet.*.id, 1)}", "${element(aws_subnet.public_subnet.*.id, 2)}"]

  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${element(aws_instance.web1.*.id, 0)}", "${element(aws_instance.web2.*.id, 0)}", "${element(aws_instance.web3.*.id, 0)}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}



 
resource "aws_instance" "web1" {

   ami = "ami-c86c3f23"
   instance_type = "t2.micro"
   key_name = "root-ssh"
   user_data = file("install_web1.sh")
  # Our Security group to allow HTTP and SSH access
   vpc_security_group_ids = ["${aws_security_group.default.id}"]
   subnet_id              = "${element(aws_subnet.public_subnet.*.id, 0)}"
   availability_zone       = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_instance" "web2" {

   ami = "ami-c86c3f23"
   instance_type = "t2.micro"
   key_name = "root-ssh"
   user_data = file("install_web2.sh")
  # Our Security group to allow HTTP and SSH access
   vpc_security_group_ids = ["${aws_security_group.default.id}"]
   subnet_id              = "${element(aws_subnet.public_subnet.*.id, 1)}"
   availability_zone       = "${data.aws_availability_zones.available.names[1]}"
}


resource "aws_instance" "web3" {

   ami = "ami-c86c3f23"
   instance_type = "t2.micro"
   key_name = "root-ssh"
   user_data = file("install_web3.sh")
  # Our Security group to allow HTTP and SSH access
   vpc_security_group_ids = ["${aws_security_group.default.id}"]
   subnet_id              = "${element(aws_subnet.public_subnet.*.id, 2)}"
   availability_zone       = "${data.aws_availability_zones.available.names[2]}"
}

