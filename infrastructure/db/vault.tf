resource "vault_policy" "policy" {
  name = "asciifier-policy"

  policy = <<EOT
path "database/creds/app_db_role"
{
  capabilities = ["read", "list"]
}
EOT
}
