variable "region" {}
variable "vpc_id" {}
variable "vpc_subnets" {
  type = "list"
}
variable "ami_id" {
  default = "ami-061e7ebbc234015fe"
}
variable "key_name" {}
variable "tags" {
    description = "Common tags to bind to AWS resources."
    type = "map"
}
