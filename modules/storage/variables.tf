variable "namespace" {
  description = "The namespace for the Redis instance."
  type        = string
}

variable "deletion_protection" {
  description = "Whether to protect the bucket from deletion."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels for the bucket."
  type        = map(string)
  default     = {}
}