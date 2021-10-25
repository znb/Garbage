variable "environment" {}
variable "vpc_id" {}

variable "availability_zones" {
  default = "eu-west-2"
}

variable "your_office_ip" {
  default = "EDITME/32"
}

variable "tcp_protocol" {
  default = "tcp"
}

variable "ssh_port" {
  default = "22"
}

variable "https_port" {
  default = "443"
}

variable "cortex_port" {
  default = "9000"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

resource "aws_security_group" "the_hive" {
  name   = "the_hive_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.the_hive.id}"
  description       = "Allow incoming SSH"

  from_port   = "${var.ssh_port}"
  to_port     = "${var.ssh_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}", "${var.your_office_ip}"]
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.the_hive.id}"
  description       = "Allow incoming HTTPS"

  from_port   = "${var.https_port}"
  to_port     = "${var.https_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.your_office_ip}"]
}

resource "aws_security_group_rule" "allow_cortex" {
  type              = "ingress"
  security_group_id = "${aws_security_group.the_hive.id}"
  description       = "Allow Hive to talk to Cortex"

  from_port   = "${var.cortex_port}"
  to_port     = "${var.cortex_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.the_hive.id}"
  description       = "Allow Hive to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "hive_sg_id" {
  value = "${aws_security_group.the_hive.id}"
}
