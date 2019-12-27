terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.7"
  
  backend "gcs" {

    bucket  = "test-tf-vpc"
    
    prefix  = "terraform/state"

   }

}

module "vpc_network" {
  source = "../modules/vpc-network"

  name_prefix = "${"${var.cluster_name}"}-network-${random_string.suffix.result}"
  project     = "${var.project}"
  region      = "${var.region}"

  cidr_block           = "${var.vpc_cidr_block}"
  secondary_cidr_block = "${var.vpc_secondary_cidr_block}"
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}