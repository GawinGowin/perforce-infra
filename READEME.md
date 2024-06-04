# Perforce-infra

```tf
resource "google_artifact_registry_repository" "container_repo" {
  location      = "asia-northeast1"
  repository_id = var.instance_name
  description   = "created_by:terraform"
  format        = "DOCKER"
}
```