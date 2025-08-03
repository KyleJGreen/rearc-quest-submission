output "quest_webapp_ip_address" {
    description = <<EOF
The IP address of the load balancer. This will be used to access the web
application.
EOF
  value = data.google_compute_global_address.quest_webapp_ip.address
}