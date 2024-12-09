variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "region" {
  type        = string
  description = "The region where the router and NAT gateway will be created"
}
