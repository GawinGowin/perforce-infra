resource "google_compute_firewall" "perforce-firewall" {
  name    = "${var.instance_name}-vpc-firewall"
  network = "default"
  project = data.google_client_config.default.project

  allow {
    protocol  = "tcp"
    ports    = ["1666"]
  }

  direction = "INGRESS"
  target_tags = [var.instance_name]
  source_ranges = ["0.0.0.0/0"]
}
