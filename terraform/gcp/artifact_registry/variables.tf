variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "Region for the Artifact Registry repository"
  default     = "us-west1"
}
