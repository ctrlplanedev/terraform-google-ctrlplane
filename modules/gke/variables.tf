variable "namespace" {
  description = "Namespace for the GKE cluster"
  type        = string
}

variable "network_self_link" {
  description = "The network self link."
  type        = string
}

variable "subnetwork_self_link" {
  description = "The subnetwork self link."
  type        = string
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the database instance."
  type        = bool
  default     = true
}

