variable "region" {
    description = "AWS region to use."
}
variable "vpc_id" {
    description = "VPC ID used for security group."
}
variable "db_subnet_group_name" {
    description = "DB subnet group name used by RDS."
}
variable "availability_zones" {
    description = "List of availability zones that will be used."
}
variable "instance_class" {
    description = "Instance type used by RDS."
    default = "db.t2.medium"
}
variable "tags" {
    description = "Common tags to bind to AWS resources."
    type = "map"
}
