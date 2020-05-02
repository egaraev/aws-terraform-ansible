variable "cluster_name"{
    default = "aws-multi-region"
}

variable "nodes_per_region" {
    default = "1"
}

module "region-1" {
    source  = "./vpc/"
    region = "eu-central-1"
    cluster_name = "${var.cluster_name}"
    region_name = "east"
    vpc_cidr = "10.0.0.0/24"
    nb_nodes = "${var.nodes_per_region}"
	peering_id = module.vpc_peer_1.peering_connection_id
}

module "region-2" {
    source  = "./vpc/"
    region = "eu-west-1"
    cluster_name = "${var.cluster_name}"
    region_name = "west"
    vpc_cidr = "11.1.1.0/24"
    nb_nodes = "${var.nodes_per_region}"
	peering_id = module.vpc_peer_1.peering_connection_id
}

module "vpc_peer_1" {
    source  = "./vpc-peer/"
    request_region = "${module.region-1.region}"
    request_vpc_id = "${module.region-1.vpc_id}"
    accept_region = "${module.region-2.region}"
    accept_vpc_id = "${module.region-2.vpc_id}"
}