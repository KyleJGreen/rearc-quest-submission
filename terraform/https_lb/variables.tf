variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default = "rearc-quest-kgreen"
}

variable "url_map_id" {
  description = <<EOF
The ID of the URL map to be used by the HTTPS proxy.
In the current setup, this is hardcoded to the URL map
created in the quest_webapp module. If the modules were to be
consolidated, this could be replaced with a reference to the field of
the URL map created in the same module. The terraform provider
does not support referencing the URL map as a data source.
EOF

  type        = string
  default = "https://www.googleapis.com/compute/v1/projects/rearc-quest-kgreen/global/urlMaps/quest-webapp-url-map"
}