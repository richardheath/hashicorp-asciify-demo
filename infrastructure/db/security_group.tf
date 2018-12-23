resource "aws_security_group" "db" {
  name                   = "hashi-demo-rds"
  description            = "Allow traffic"
  revoke_rules_on_delete = true
  tags                   = "${var.tags}"
  vpc_id                 = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "Allow MySql traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
