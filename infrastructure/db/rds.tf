resource "random_string" "initial_db_password" {
  length           = 16
  special          = false
  override_special = " "
}

resource "aws_rds_cluster" "db" {
  cluster_identifier      = "hashi-demo"
  engine                  = "aurora"
  availability_zones      = "${var.availability_zones}"
  database_name           = "asciifier"
  master_username         = "sa"
  master_password         = "${random_string.initial_db_password.result}"
  vpc_security_group_ids  = ["${aws_security_group.db.id}"]
  backup_retention_period = 30
  preferred_backup_window = "07:00-09:00"
  tags                    = "${var.tags}"
  db_subnet_group_name    = "${var.db_subnet_group_name}"
}

resource "aws_rds_cluster_instance" "db" {
  count                = 1
  identifier           = "hashi-demo"
  cluster_identifier   = "${aws_rds_cluster.db.id}"
  instance_class       = "${var.instance_class}"
  tags                 = "${var.tags}"
  db_subnet_group_name = "${var.db_subnet_group_name}"
  apply_immediately    = "true"
}
