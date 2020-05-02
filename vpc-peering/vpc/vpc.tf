# Required Variables

variable "region" {}
variable "cluster_name" {}
variable "region_name" {}
variable "nb_nodes" {}
variable "vpc_cidr" {}

# Default Variables

variable "instance_type" {
    default = "t2.micro"
}

variable "public_key_path" {
    default = "/root/.ssh/id_rsa.pub"
}



variable "ami-username" {
    default = "ec-2"
}

variable "ami" {
    type = "map"

    default = {
        eu-central-1 = "ami-c86c3f23"
        eu-west-1 = "ami-bb9a6bc2"
    }
}

variable "availability_zone" {
    type = "map"

    default = {
        eu-central-1 = "eu-central-1a"
        eu-west-1 = "eu-west-1a"
    }
}

provider "aws" {
    region = "${var.region}"
}

# Network Resources

resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true

    tags = {
        Name = "${var.cluster_name}-${var.region_name}-vpc"
    }
}

resource "aws_subnet" "subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.vpc_cidr}"
    availability_zone = "${lookup(var.availability_zone, var.region)}"

    tags = {
        Name = "${var.cluster_name}-${var.region_name}-subnet"
    }
}

resource "aws_security_group" "sg" {
    name = "vpc_test"
    description = "Allow all"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id="${aws_vpc.vpc.id}"

    tags = {
        Name = "${var.cluster_name}-${var.region_name}-security-group"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Name = "${var.cluster_name}-${var.region_name}-gateway"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags = {
        Name = "${var.cluster_name}-${var.region_name}-subnet-rt"
    }
}

resource "aws_route_table_association" "public-rt" {
    subnet_id = "${aws_subnet.subnet.id}"
    route_table_id = "${aws_route_table.public-rt.id}"
}


# Instance Resources

resource "aws_key_pair" "kp" {
    key_name = "${var.cluster_name}-${var.region_name}-key"
    public_key = "${file("${var.public_key_path}")}"
}

resource "aws_instance" "node" {
    ami = "${lookup(var.ami, var.region)}"
    instance_type = "${var.instance_type}"
    count = "${var.nb_nodes}"

    key_name = "${aws_key_pair.kp.id}"
    subnet_id = "${aws_subnet.subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.sg.id}"]
    source_dest_check = false
    associate_public_ip_address = true

    root_block_device {
        volume_size = 20
    }

    tags = {
        Name = "${var.cluster_name}-${var.region_name}-${count.index}"
    }
}

output "region" {
    value = "${var.region}"
}

output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}
