resource "google_compute_instance" "quest_webapp" {
  name         = "quest-webapp"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email  = "default"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  metadata = {
    "gce-container-declaration" = <<-EOT
      spec:
        containers:
          - name: web
            image: us-central1-docker.pkg.dev/${var.project_id}/quest/quest-webapp:latest
            ports:
              - containerPort: 3000
        restartPolicy: Always
    EOT
  }

  tags = ["quest-webapp", "allow-health-check", "http-server", "https-server", "lb-health-check"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-htttp-quest-webapp"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["quest-webapp"]
}

resource "google_compute_instance_group" "quest_webpp_ig" {
  name      = "quest-webapp-instance-group"
  zone      = "us-central1-a"
  instances = [google_compute_instance.quest_webapp.self_link]

  named_port {
    name = "http"
    port = 3000
  }
}

resource "google_compute_health_check" "quest-webapp-backend-hc" {
  project = var.project_id
  name = "quest-webapp-healthcheck"

  http_health_check {
    port = 3000
    request_path = "/health"
  }
}

resource "google_compute_backend_service" "quest_webapp_backend" {
  name                  = "quest-webapp-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  port_name             = "http"
  timeout_sec           = 30

  backend {
    group = google_compute_instance_group.quest_webpp_ig.self_link
  }

  health_checks = [google_compute_health_check.quest-webapp-backend-hc.self_link]
}

resource "google_compute_url_map" "quest_webapp_url_map" {
  name            = "quest-webapp-url-map"
  default_service = google_compute_backend_service.quest_webapp_backend.self_link
}

# Redirect HTTP to HTTPS
resource "google_compute_url_map" "http_to_https_redirect" {
  name = "quest-http-to-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"  # 301
    strip_query            = false
  }
}

resource "google_compute_global_address" "quest_webapp_ip" {
  name = "quest-webapp-ip"
}

# This http proxy is used to redirect HTTP traffic to HTTPS
resource "google_compute_target_http_proxy" "quest_webapp_redirect_proxy" {
  name    = "quest-webapp-http-proxy"
  url_map = google_compute_url_map.http_to_https_redirect.id
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
    name                  = "quest-webapp-http-forwarding-rule"
    target                = google_compute_target_http_proxy.quest_webapp_redirect_proxy.id
    port_range            = "80"
    ip_protocol           = "TCP"
    load_balancing_scheme = "EXTERNAL"
    ip_address            = google_compute_global_address.quest_webapp_ip.address
}