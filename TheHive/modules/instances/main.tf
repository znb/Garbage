variable "hive_sg_id" {}
variable "subnet_id" {}

variable "region" {
  default = "eu-west-2"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "large_instance_type" {
  default = "t2.large"
}

variable "medium_instance_type" {
  default = "t2.medium"
}

variable "hive_ami" {
  default = "ami-996372fd"
}

variable "cortex_ami" {
  default = "ami-996372fd"
}

variable "key_name" {
  default = "your_aws_ssh_key_here"
}

variable "security_groups" {
  type = "list"
}

resource "aws_instance" "the_hive" {
  ami                         = "${var.hive_ami}"
  instance_type               = "${var.large_instance_type}"
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name  = "thehive"
    Owner = "Information Security"
    Role  = "Incident Response Platform"
  }

  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.hive_sg_id}"]
  key_name               = "${var.key_name}"

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file("ssh-keys/your_aws_ssh_key_here.pem")}"
  }

  provisioner "file" {
    source      = "files/post_install-thehive.sh"
    destination = "/home/ubuntu/post_install-thehive.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/post_install-thehive.sh",
      "sudo bash /home/ubuntu/post_install-thehive.sh",
    ]
  }

  provisioner "file" {
    source      = "files/hive-to-cortex"
    destination = "/home/ubuntu/.ssh/hive-to-cortex"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/hive-to-cortex",
      "chmod 700 /home/ubuntu/.ssh",
    ]
  }

  provisioner "file" {
    source      = "files/hive-application.conf"
    destination = "/home/ubuntu/application.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/application.conf /etc/thehive",
      "sudo chown root.root /etc/thehive/application.conf",
    ]
  }

  provisioner "file" {
    source      = "files/elasticsearch.yml"
    destination = "/home/ubuntu/elasticsearch.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/elasticsearch.yml /etc/elasticsearch",
      "sudo chown root.root /etc/elasticsearch/elasticsearch.yml",
    ]
  }

  provisioner "file" {
    source      = "files/nginx-thehive.conf"
    destination = "/home/ubuntu/thehive.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/thehive.conf /etc/nginx/sites-available/",
      "sudo chown root.root /etc/nginx/sites-available/thehive.conf",
      "sudo ln -s /etc/nginx/sites-available/thehive.conf /etc/nginx/sites-enabled/",
      "sudo rm /etc/nginx/sites-enabled/default",
    ]
  }

  provisioner "file" {
    source      = "files/nginx.conf"
    destination = "/home/ubuntu/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/nginx.conf /etc/nginx/",
      "sudo chown root.root /etc/nginx/nginx.conf",
    ]
  }

  provisioner "file" {
    source      = "files/ssh-config"
    destination = "/home/ubuntu/.ssh/config"
  }
}

resource "aws_eip" "the_hive" {
  instance = "${aws_instance.the_hive.id}"
  vpc      = true
}

resource "aws_instance" "cortex" {
  ami                         = "${var.cortex_ami}"
  instance_type               = "${var.medium_instance_type}"
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name  = "cortex"
    Owner = "Information Security"
    Role  = "Incident Response Platform"
  }

  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.hive_sg_id}"]
  key_name               = "${var.key_name}"

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file("ssh-keys/your_aws_ssh_key_here.pem")}"
  }

  provisioner "file" {
    source      = "files/post_install-cortex.sh"
    destination = "/home/ubuntu/post_install-cortex.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/post_install-cortex.sh",
      "sudo bash /home/ubuntu/post_install-cortex.sh",
    ]
  }

  provisioner "file" {
    source      = "files/cortex-application.conf"
    destination = "/home/ubuntu/application.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/application.conf /etc/cortex",
      "sudo chown root.root /etc/cortex/application.conf",
    ]
  }

  provisioner "file" {
    source      = "files/authorized_keys"
    destination = "/home/ubuntu/.ssh/authorized_keys"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chmod 700 /home/ubuntu/.ssh",
    ]
  }
}
