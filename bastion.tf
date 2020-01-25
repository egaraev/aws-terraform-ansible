
# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "rootkey"
  public_key = "${file("${var.key_path}")}"
}

################ BASTION HOST

# Keypair for Bastion host
resource "aws_key_pair" "bastion_host_key" {
  key_name   = "bastion_host_key"
  public_key = "${file(var.bastion_host_public_key)}"
}

# Bastion Host AMI
data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"] # ubuntu
}

# Bastion Host Security Group
resource "aws_security_group" "bastion_host" {
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    
    // replace with your remote IP address, or CIDR block
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${aws_subnet.public_subnet.cidr_block}",
      "${aws_subnet.private_subnet.cidr_block}",
      "${aws_subnet.isolated_subnet.cidr_block}",
    ]
  }
}

# Bastion host EC2 instance
resource "aws_instance" "bastion_host" {
  ami           = "${data.aws_ami.ubuntu_ami.id}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.bastion_host_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion_host.id}"]
  subnet_id              = "${aws_subnet.public_subnet.id}"
  associate_public_ip_address = true
    
  tags {
    Name = "bastion_host"
  }
  provisioner "remote-exec" {
    inline = ["id"]
  }
  provisioner "local-exec" {
        command = "ansible-playbook -u ubuntu -i ec2.py tag_Name_bastion_host ansible/setup_bastion.yml"
  }
}

