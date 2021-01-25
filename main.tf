resource "vault_consul_secret_backend" "consul" {
  path  = var.path

  address = var.consul_address
  scheme  = local.scheme
  token   = var.consul_token

  default_lease_ttl_seconds = var.consul_default_lease
  max_lease_ttl_seconds     = var.consul_max_lease
}

resource "vault_consul_secret_backend_role" "consul" {
  name    = var.consul_backend_role_name
  backend = vault_consul_secret_backend.consul.path

  policies   = var.consul_policies
  local      = var.consul_local_token
  token_type = var.consul_token_type

  ttl     = var.consul_default_lease
  max_ttl = var.consul_max_lease
}
