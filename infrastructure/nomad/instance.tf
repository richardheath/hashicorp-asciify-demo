data "template_file" "userdata_script" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    consul_nomad_server_token = "${var.consul_nomad_server_token}"
    consul_client_token       = "${var.consul_client_token}"
    vault_address             = "${var.vault_address}"
    vault_token               = "${var.vault_token}"
  }
}

resource "aws_launch_configuration" "server" {
  name_prefix                 = "nomad-demo-"
  image_id                    = "${var.ami_id}"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.server.name}"
  security_groups             = ["${aws_security_group.server.id}"]
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.userdata_script.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "server" {
  name                 = "nomad-demo"
  launch_configuration = "${aws_launch_configuration.server.name}"
  min_size             = "1"
  max_size             = "1"
  vpc_zone_identifier  = ["${var.vpc_subnets}"]

  tags = ["${concat(
      list(
        map("key", "Name", "value", "nomad-demo", "propagate_at_launch", true),
      )
  )}"]

  lifecycle {
    create_before_destroy = true
  }
}
