variable "region" {}
variable "vpc_id" {}
variable "aws_account_number" {}

variable "vpc_subnets" {
  type = "list"
}

variable "ami_id" {
  default = "ami-061e7ebbc234015fe"
}
variable "key_name" {}

variable "consul_vault_server_token" {}
variable "consul_client_token" {}
