resource "google_redis_instance" "this" {
  name         = "${var.namespace}-redis"
  display_name = "${var.namespace} Ctrlplane Instance"

  tier           = var.tier
  memory_size_gb = var.memory_size_gb

  authorized_network = var.network_id

  auth_enabled = true

  redis_configs = {
    maxmemory_policy = "noeviction"
  }

  persistence_config {
    persistence_mode    = "RDB"
    rdb_snapshot_period = var.rdb_snapshot_period
  }
}
