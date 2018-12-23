variable "region" {
    description = "AWS region to use."
}
variable "vpc_id" {}
variable "aws_account_number" {}

variable "vpc_subnets" {
  type = "list"
}

variable "ami_id" {
  default = "ami-061e7ebbc234015fe"
}
variable "worker_ami_id" {
  default = "ami-061e7ebbc234015fe"
}
variable "key_name" {}

variable "consul_nomad_server_token" {}
variable "consul_nomad_client_token" {}
variable "consul_client_token" {}

variable "vault_address" {}
variable "vault_token" {}

variable "nomad_address" {}
variable "kms_alias" {}
variable "tags" {
    description = "Common tags to bind to AWS resources."
    type = "map"
}
