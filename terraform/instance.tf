variable "image_tag" {
	type = string
  default = "latest"
}

variable "container" {
  type = string
  default = "asia-northeast1-docker.pkg.dev/vivid-willow-381410/perforce-server/x-tech-perforce"
}

resource "google_compute_instance" "perforce-server" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = "asia-northeast1-a"

  boot_disk {
    auto_delete = true
    device_name = "instance-20240604-073929"

    initialize_params {
      image = "projects/cos-cloud/global/images/cos-101-17162-463-29"
      size  = 10
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.perforce_ip.address
    }
  }

  service_account {
    email  = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
    scopes = [
		"https://www.googleapis.com/auth/devstorage.read_only",
		"https://www.googleapis.com/auth/logging.write",
		"https://www.googleapis.com/auth/monitoring.write",
		"https://www.googleapis.com/auth/service.management.readonly",
		"https://www.googleapis.com/auth/servicecontrol",
		"https://www.googleapis.com/auth/trace.append"
	  ]
  }
  metadata = {
    created_by = "terraform"
    gce-container-declaration = <<-EOT
      spec:
        containers:
        - name: perforce-server
          image: ${var.container}:${var.image_tag}
          volumeMounts:
          - name: perforce-data
            readOnly: false
            mountPath: /opt/perforce/servers
          securityContext:
            privileged: true
          stdin: false
          tty: false
        volumes:
        - name: perforce-data
          gcePersistentDisk:
            pdName: ${google_compute_disk.default.name}
            fsType: ext4
            partition: 0
            readOnly: false
        restartPolicy: Always
      EOT
  }
  attached_disk {
    source      = google_compute_disk.default.id
    device_name = google_compute_disk.default.name
	mode = "READ_WRITE"
  }
  tags = [var.instance_name]
}

resource "google_compute_disk" "default" {
  name = "perforce-data"
  type = "pd-standard"
  zone = "asia-northeast1-a"
  size = "40"
}

resource "google_compute_address" "perforce_ip" {
  name   = "${var.instance_name}-ip"
  region = "asia-northeast1"
}

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
