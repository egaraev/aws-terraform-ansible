# Define the security group for public subnet
resource "aws_security_group" "sgapp" {
  name = "vpc_app"
  description = "Allow incoming HTTP connections & SSH access"


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
    Name = "APP SG"
  }
}