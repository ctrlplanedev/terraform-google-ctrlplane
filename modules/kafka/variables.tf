variable "namespace" {
  type        = string
  description = "The name prefix for all resources created."
}

variable "subnetwork_self_link" {
  description = "The subnetwork self link."
  type        = string
}
