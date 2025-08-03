resource "google_artifact_registry_repository" "docker_repo" {
  provider = google
  project = var.project_id
  location      = var.region
  repository_id = "quest"
  format        = "DOCKER"
  description   = "Docker repository for my submission to the quest"

}
