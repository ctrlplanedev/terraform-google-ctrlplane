variable "namespace" {
  description = "Namespace for the service accounts"
  type        = string
}

variable "bucket_name" {
  description = "The GCS bucket name to grant access to"
  type        = string
}
