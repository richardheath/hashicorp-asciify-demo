// Give Vault SA credentials so it can generate
// temporary credentials and rotate SA password.
resource "null_resource" "mysql_db_connection" {
  triggers = {
    endpoint         = "${aws_rds_cluster_instance.db.endpoint}"
    initial_password = "${random_string.initial_db_password.result}"
  }

  provisioner "local-exec" {
    command = <<SCRIPT
    sleep 1m
    vault write database/config/hashi_demo \
    plugin_name=mysql-rds-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(${aws_rds_cluster_instance.db.endpoint}:3306)/" \
    allowed_roles="app_db_role,admin_db_role*" \
    username="sa" \
    password="${random_string.initial_db_password.result}"
SCRIPT
  }

  depends_on = ["aws_rds_cluster.db"]
}

// App role that is limited to only INSERT permission
// to asciifier DB.
resource "vault_database_secret_backend_role" "app_db_role" {
  backend = "database"
  name    = "app_db_role"
  db_name = "hashi_demo"

  creation_statements = <<SQL
CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';
GRANT INSERT ON asciifier.* TO '{{name}}'@'%';
SQL

  default_ttl = 86400                                 // 24 hrs
  max_ttl     = 86400                                 // 24 hrs
  depends_on  = ["null_resource.mysql_db_connection"]
}

// db role with all priviledge to asciifier DB
resource "vault_database_secret_backend_role" "admin_db_role" {
  backend = "database"
  name    = "admin_db_role"
  db_name = "hashi_demo"

  creation_statements = <<SQL
CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';
GRANT ALL PRIVILEGES ON asciifier.* TO '{{name}}'@'%';
SQL

  default_ttl = 28800                                 // 8 hrs
  max_ttl     = 28800                                 // 8 hrs
  depends_on  = ["null_resource.mysql_db_connection"]
}
