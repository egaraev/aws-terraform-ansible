provider "aws" {
   region = "eu-central-1"
}

resource "aws_s3_bucket" "b" {
  bucket = "eldar-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "LAB"
  }
}
