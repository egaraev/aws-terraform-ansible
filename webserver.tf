# Define webserver inside the public subnet
resource "aws_instance" "wb" {
   ami  = "${var.rhel_ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public_subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("${var.web_bootstrap_path}")}"

  tags {
    Name = "webserver"
  }
}