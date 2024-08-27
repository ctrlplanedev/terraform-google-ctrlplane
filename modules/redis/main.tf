resource "google_redis_instance" "this" {
  name         = "${var.namespace}-redis"
  display_name = "${var.namespace} Ctrlplane Instance"

  tier           = var.tier
  memory_size_gb = var.memory_size_gb

  authorized_network = var.network_id

  auth_enabled = true

  transit_encryption_mode = "SERVER_AUTHENTICATION"
}
