variable "project_id" {
  description = "GCP project ID to deploy into"
  type        = string
}

variable "region" {
  description = "GCP region for all resources"
  type        = string
  default     = "us-central1"
}

variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "ctrlplane"
}

variable "postgres_tier" {
  description = "Cloud SQL machine tier (db-custom-VCPU-RAM_MB)"
  type        = string
  default     = "db-custom-1-3840"
}

variable "postgres_disk_size_gb" {
  description = "Cloud SQL disk size in GB"
  type        = number
  default     = 10
}

variable "postgres_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "POSTGRES_15"
}

variable "kafka_vcpu_count" {
  description = "Managed Kafka vCPU count (minimum 3)"
  type        = number
  default     = 3
}

variable "kafka_memory_bytes" {
  description = "Managed Kafka memory in bytes (minimum 3 GiB)"
  type        = number
  default     = 3221225472 # 3 GiB
}
