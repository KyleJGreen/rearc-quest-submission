resource "google_artifact_registry_repository" "docker_repo" {
  provider = google

  location      = "us-central1"
  repository_id = "quest"
  format        = "DOCKER"
  description   = "Docker repository for my submission to the quest"

}
