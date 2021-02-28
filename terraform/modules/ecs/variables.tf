variable "tags" {
  type = map(string)
}
variable "project_name" {
  type = string
}
variable "region" {
  type = string
}
variable "domain" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "route53_zone_id" {
  type = string
}
variable "acm_cert_arn" {
  type = string
}

variable "security_group_ids" {
  type = map(string)
}
variable "subnet_ids" {
  type = map(string)
}