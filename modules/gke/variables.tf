variable "namespace" {
  description = "Namespace for the GKE cluster"
  type        = string
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances to host Ctrlplane."
  type        = object({ email = string })
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}

variable "machine_type" {
  description = "The machine type for the cluster"
  type        = string
  default     = "n4-standard-4"
}

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 1
}
