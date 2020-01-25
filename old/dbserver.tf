# Define database inside the private subnet
resource "aws_instance" "db" {
   ami  = "${var.rhel_ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private_subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgdb.id}"]
   associate_public_ip_address = false
   source_dest_check = false
   user_data = "${file("${var.db_bootstrap_path}")}"

  tags {
    Name = "database"
  }
}