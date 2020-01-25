############################################################
## CREATE ROUTING TABLE

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
#  count = "${length(aws_subnet.public_subnet.*.id)}"
#  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"

}


# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgw.id}"
  }
}

resource "aws_route_table_association" "private_rt_association" {
#  count = "${length(aws_subnet.private_subnet.*.id)}"
#  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}




# Isolated Route Table
resource "aws_route_table" "isolated_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgw.id}"
  }
}

resource "aws_route_table_association" "isolated_rt_association" {
#  count = "${length(aws_subnet.isolated_subnet.*.id)}"
#  subnet_id      = "${element(aws_subnet.isolated_subnet.*.id, count.index)}"
  subnet_id      = "${aws_subnet.isolated_subnet.id}"
  route_table_id = "${aws_route_table.isolated_route_table.id}"
}