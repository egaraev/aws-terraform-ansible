provider "aws" {
   region = "eu-central-1"
}

resource "aws_key_pair" "root-ssh" {
   key_name = "root-ssh"
   public_key = "${file("/root/.ssh/id_rsa.pub")}"
}
 
resource "aws_instance" "test-vm" {
   ami = "ami-c86c3f23"
   instance_type = "t2.micro"
   key_name = "root-ssh"
   tags {
     Name = "test-vm"
   }
}
