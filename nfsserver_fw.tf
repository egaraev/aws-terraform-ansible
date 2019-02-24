# Define the security group for private subnet
resource "aws_security_group" "sgnfs"{
  name = "vpc_nfs"
  description = "Allow NFS traffic from public subnet"

  ingress {
    from_port = 111
    to_port = 111
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]
  }

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]
  }


  ingress {
    from_port = 111
    to_port = 111
    protocol = "udp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]
  }

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "udp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]
  }


  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "NFS SG"
  }
}