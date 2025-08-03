variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default = "rearc-quest-kgreen"
}

variable "region" {
  type        = string
  description = "Region for the Artifact Registry repository"
  default     = "us-central1"
}
