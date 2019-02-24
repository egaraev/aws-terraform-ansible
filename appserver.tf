# Define webserver inside the public subnet
resource "aws_instance" "app" {
   ami  = "${var.rhel_ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public_subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgapp.id}"]
   associate_public_ip_address = false
   source_dest_check = false
#   user_data = "${file("${var.app_bootstrap_path}")}"

  tags {
    Name = "appserver"
  }
}