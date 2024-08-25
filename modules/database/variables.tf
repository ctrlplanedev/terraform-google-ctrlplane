variable "namespace" {
  description = "Namespace for the database"
  type        = string
}

variable "database_version" {
  description = "Version for Postgres"
  type        = string
  default     = "POSTGRES_16"
}

variable "network_connection" {
  description = "The private service networking connection that will connect Postgres to the network."
  type        = object({ network = string })
}

variable "tier" {
  description = "The tier for the Postgres instance"
  type        = string
  default     = "db-f1-micro"
}
