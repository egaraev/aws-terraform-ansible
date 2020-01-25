# Define nfsserver inside the isolated subnet
resource "aws_instance" "nfs" {
   ami  = "${var.aws_ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.isolated_subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgnfs.id}"]
   associate_public_ip_address = false
   source_dest_check = false
   user_data = "${file("${var.nfs_bootstrap_path}")}"

  tags {
    Name = "nfsserver"
  }
}
