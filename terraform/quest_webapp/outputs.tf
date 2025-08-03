output "lb_ip_address" {
    description = <<EOF
The IP address of the load balancer. This will be used to access the web
application and generate its self-signed certificate.
EOF
    value       = google_compute_global_address.quest_webapp_ip.address
}