provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  profile    = "${var.profile}"
}

module "network" {
  source            = "./modules/network"
  vpc_cidr_block    = "10.0.0.0/16"
  availability_zone = "${var.availability_zone}"
}

module "security-groups" {
  source      = "./modules/security-groups"
  environment = "infosec"
  vpc_id      = "${module.network.vpc_id}"
}

module "instances" {
  source          = "./modules/instances"
  subnet_id       = "${module.network.aws_subnet_id}"
  security_groups = ["${module.security-groups.hive_sg_id}"]
  hive_sg_id      = "${module.security-groups.hive_sg_id}"
}
