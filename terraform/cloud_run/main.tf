# This is not the solution I ended up using for the Quest, but I decided to keep it for reference.
resource "google_cloud_run_v2_service" "webapp" {
  name     = "quest-webapp"
  location = var.region
  deletion_protection = false

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/quest/quest-webapp:latest"

      ports {
        container_port = 3000  # Port exposed by the container
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
}

resource "google_cloud_run_service_iam_member" "public-access" {
  service  = google_cloud_run_v2_service.webapp.name
  location = google_cloud_run_v2_service.webapp.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
