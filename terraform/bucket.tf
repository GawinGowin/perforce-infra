resource "google_storage_bucket" "bucket" {
  name          = "${var.instance_name}-bucket"
  force_destroy = true
  location      = "ASIA-NORTHEAST1"
  storage_class = "STANDARD"
  project       = data.google_client_config.default.project
  uniform_bucket_level_access = true
  lifecycle {
    prevent_destroy = false
  }
}
