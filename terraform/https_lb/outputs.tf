output "quest_webapp_ip_address" {
  value = data.google_compute_global_address.quest_webapp_ip.address
}