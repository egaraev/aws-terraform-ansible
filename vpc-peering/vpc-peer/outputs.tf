output "peering_connection_id" {
  value       = "${aws_vpc_peering_connection.peer.id}"
  description = "Peering connection id"
}