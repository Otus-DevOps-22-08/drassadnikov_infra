output "external_ip_addresses_app" {
  value = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
}
