output "external_ip_addresses_app" {
  value = module.app.external_ip_addresses_app
}

output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}
#output "load_balancer_ip_address" {
#  value = yandex_lb_network_load_balancer.loadbalancer.listener.*.external_address_spec[0].*.address[0]
#}
