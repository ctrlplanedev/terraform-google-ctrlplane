variable "namespace" {
  description = "Namespace for the GKE cluster"
  type        = string
}

variable "service_account_email" {
  description = "The service account email associated with the GKE cluster instances to host Ctrlplane."
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

variable "machine_type" {
  description = "The machine type for the cluster"
  type        = string
  default     = "n2-standard-4"
}

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 1
}
