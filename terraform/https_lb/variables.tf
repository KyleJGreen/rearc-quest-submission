variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default = "rearc-quest-kgreen"
}

variable "url_map_id" {
  description = "The ID of the URL map to be used by the HTTPS proxy."
  type        = string
  default = "https://www.googleapis.com/compute/v1/projects/rearc-quest-kgreen/global/urlMaps/quest-webapp-url-map"
}