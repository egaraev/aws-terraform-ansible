# Define AWS as our provider
provider "aws" {
  region = "${var.aws_region}"
  version = "~> 2.8.0"
}
