locals {
  secret_id = "projects/${data.google_project.project.number}/secrets/perforce-root-pw"
}


resource "google_cloud_run_v2_service" "default" {
	name     = "${var.instance_name}-srv"
	location = "asia-northeast1"
	ingress = "INGRESS_TRAFFIC_ALL"
	launch_stage = "BETA"
	template {
		containers {
			name = "perforce"
			image = "asia-northeast1-docker.pkg.dev/vivid-willow-381410/perforce-server/x-tech-perforce"
			ports {
				container_port = 1666
			}
			env {
				name = "P4D_PASSWORD"
				value_source {
					secret_key_ref {
						secret = local.secret_id
						version = "1"
					}
				}
			}
			env {
				name = "P4D_ROOT"
				value = "/p4-data"
			}
			volume_mounts {
				name = "perforce-volume"
				mount_path = "/p4-data"
			}
			resources {
				limits = {
					cpu    = "2"
					memory = "1024Mi"
				}
			}
		}
		volumes {
			name = "perforce-volume"
			gcs {
				bucket    = google_storage_bucket.bucket.name
				read_only = false
			}
		}
		scaling {
			max_instance_count = 2
		}
	}
	depends_on = [ google_storage_bucket.bucket, google_secret_manager_secret_iam_member.secret-access ]
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = local.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}