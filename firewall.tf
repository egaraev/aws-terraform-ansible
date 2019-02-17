##########################################################
##CREATE SECURITY GROUPS
# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
  name = "vpc_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443 
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

## for NFS 

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


## for NFS


  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.main.id}"

  tags {
    Name = "Web Server SG"
  }
}


# Define the security group for private subnet
resource "aws_security_group" "sgdb"{
  name = "vpc_db"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_block}"]   #access to mysql only from public subnet cidr
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "DB SG"
  }
}



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