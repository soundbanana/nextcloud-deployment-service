output "url" {
  value = "http://${yandex_compute_instance.server.network_interface[0].nat_ip_address}/nextcloud/index.php"
}

output "dns" {
  value = "http://${yandex_dns_recordset.recordset.name}.${yandex_dns_zone.zone.zone}/nextcloud/index.php"
}