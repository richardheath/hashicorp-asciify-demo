data "aws_kms_alias" "key" {
  name = "${var.kms_alias}"
}

resource "aws_ami_copy" "encrypted_worker_ami" {
  name              = "nomad-demo-worker"
  description       = "A copy of ${var.worker_ami_id}"
  source_ami_id     = "${var.worker_ami_id}"
  source_ami_region = "${var.region}"
  encrypted         = true
  kms_key_id        = "${data.aws_kms_alias.key.target_key_arn}"

  tags = "${local.tags}"
}
