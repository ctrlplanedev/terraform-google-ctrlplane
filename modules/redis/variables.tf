variable "namespace" {
  description = "The namespace for the Redis instance."
  type        = string
}

variable "network_id" {
  description = "The network id."
  type        = string
}

variable "tier" {
  description = "The tier for the Redis instance."
  type        = string
}

variable "memory_size_gb" {
  description = "The memory size for the Redis instance."
  type        = number
}

variable "rdb_snapshot_period" {
  description = "The snapshot period for the Redis instance."
  type        = string
}
