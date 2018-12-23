# Asciifier DB Infrastructure

Terraform code to bootstrap Asciifier DB. 

## Prerequisite

This TF project requires Vault to be installed and authenticated
with a user with write access to `database/*` secret engine.
VAULT_ADDR environment variable needs to be set with Vault server.

Also Vault Server is expected to be configured to enabled Database
secret engine on path `database`.

## DB Creation

This will create an RDS MySQL Aurora DB using a random password
as initial password.

## Registering DB to Vault

Once DB is up `null_resource.mysql_db_connection` will register the
DB to vault (under path `database/config/hashi_demo`). This command
will give it SA credentials so it can manage temporary user accounts
and SA password rotation.

Used null resource since there's no TF resource at time of writing.

## Vault Database Secret Backend Role

Backend roles are used to give specific database access to different
roles that is going to use hashi-demo DB. This allows user/application
that have read permission to these roles ability to create temporary
credentials.

### admin_db_role

Since this is an admin role we give the user full access to asciifier
DB. This credential only lasts for 8 hours.

### app_db_role

This role is meant to be used by asciifier service. The service only
needs `INSERT` permission so it is limited to only that action. This
allows fine grained control on DB access per DB role that is created.
Since this is a long running service we are allowing this account to
last for 24 hours.

## Initialize DB Schema Using Admin Role

Before asciifier can use DB initial schema needs to be created.

```bash
vault read database/creds/admin_db_role > ./db_cred.txt
DB_ENDPOINT=db_ednpoint # replace with created RDS database.
USERNAME=$(awk '$1 == "username" { print $2; }' ./db_cred.txt)
PASSWORD=$(awk '$1 == "password" { print $2; }' ./db_cred.txt)
mysql -h $DB_ENDPOINT -u $USERNAME -p$PASSWORD -e "USE asciifier; CREATE TABLE track (imageUrl VARCHAR(255), result MEDIUMTEXT, createdDate DATE);"
```

