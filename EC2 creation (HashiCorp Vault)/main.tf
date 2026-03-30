provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "token-ID generated"
}

data "vault_kv_secret_v2" "secret" {
  mount = "Trial"
  name  = "secret"
}

output "username" {
  value     = data.vault_kv_secret_v2.secret.data["username"]
  sensitive = true
}

output "password" {
  value     = data.vault_kv_secret_v2.secret.data["password"]
  sensitive = true
}
