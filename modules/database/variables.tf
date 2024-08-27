variable "namespace" {
  description = "Namespace for the database"
  type        = string
}

variable "postgres_version" {
  description = "Version for Postgres"
  type        = string
  default     = "POSTGRES_16"
}

variable "network_connection_string" {
  description = "The private service networking connection string that will connect Postgres to the network."
  type        = string
}

variable "postgres_tier" {
  description = "The tier for the Postgres instance"
  type        = string
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the database instance."
  type        = bool
  default     = true
}
