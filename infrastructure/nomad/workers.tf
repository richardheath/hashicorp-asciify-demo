data "template_file" "userdata_worker_script" {
  template = "${file("${path.module}/userdata_worker.sh")}"

  vars {
    consul_nomad_client_token = "${var.consul_nomad_client_token}"
    consul_client_token       = "${var.consul_client_token}"
    vault_address             = "${var.vault_address}"
    vault_token               = "${var.vault_token}"
    nomad_address             = "${var.nomad_address}"
  }
}

resource "aws_launch_configuration" "worker" {
  name_prefix                 = "nomad-worker-demo-"
  image_id                    = "${aws_ami_copy.encrypted_worker_ami.id}"
  instance_type               = "m5.large"
  iam_instance_profile        = "${aws_iam_instance_profile.server.name}"
  security_groups             = ["${aws_security_group.server.id}"]
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.userdata_worker_script.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  name                 = "nomad-worker-demo"
  launch_configuration = "${aws_launch_configuration.worker.name}"
  min_size             = "1"
  max_size             = "1"
  vpc_zone_identifier  = ["${var.vpc_subnets}"]

  tags = ["${concat(
      list(
        map("key", "Name", "value", "nomad-worker-demo", "propagate_at_launch", true),
      )
  )}"]

  lifecycle {
    create_before_destroy = true
  }
}
