output "url" {
  value = "http://${yandex_compute_instance.server.network_interface[0].nat_ip_address}/nextcloud/index.php"
}