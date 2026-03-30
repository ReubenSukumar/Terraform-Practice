🔐 Vault + Terraform Setup & Troubleshooting Guide
📌 Objective
Securely store sensitive data (PEM files, credentials) in Vault
Access secrets via CLI and Terraform
Use AppRole for authentication
Avoid exposing secrets in code/state
🏗️ 1. Vault Setup (CLI Basics)
Initialize Vault
```text
vault operator init -key-shares=5 -key-threshold=3
```
Output:
5 Unseal Keys
1 Root Token
Unseal Vault
vault operator unseal

Repeat 3 times with different keys.

Set Vault Address
```text
export VAULT_ADDR='http://127.0.0.1:8200'
```

👉 Required so CLI knows where Vault is running

Login
```text
vault login
```
Paste root token.

🔑 2. Enable KV Secret Engine (KV v2)
```text
vault secrets enable -path=trial kv-v2
```
🔐 3. Store Secrets (Including PEM Files)
Store normal secrets
```text
vault kv put trial/myapp username=reuben password=test123
```
Store PEM file securely
```text
vault kv put trial/pem private_key=@mykey.pem
```

👉 Vault stores it as encrypted data
👉 No need to keep PEM on disk anymore

🔍 4. Read Secrets
```text
vault kv get trial/myapp
```
Access specific field
```text
vault kv get -field=username trial/myapp
```
🧠 KV v2 Concepts (Important)
Internal structure:
```text
trial/data/myapp        → actual secret
trial/metadata/myapp    → version metadata
```

👉 Policies must use /data/ path

🗑️ 5. Delete / Undelete / Destroy (KV v2)
Soft delete (versioned)
```text
vault kv delete trial/myapp
```

👉 Secret can be recovered

Undelete
```text
vault kv undelete -versions=1 trial/myapp
```
Permanent delete (destroy)
```text
vault kv destroy -versions=1 trial/myapp
```

👉 Cannot be recovered ❌

🛡️ 6. Policies
Create policy file (myapp-policy.hcl)
```text
path "trial/data/myapp" {
  capabilities = ["read"]
}
```
Apply policy
```text
vault policy write myapp-policy myapp-policy.hcl
```
❌ Issue: Permission Denied (403)
Error:
```text
permission denied
```
Root Cause:
Token doesn’t have admin privileges
Fix:

Login with root token:
```text
vault login
```
🔐 7. AppRole Authentication
Enable AppRole
```text
vault auth enable approle
```
Create role
```text
vault write auth/approle/role/my-role \
    token_policies="myapp-policy"
```
Get Role ID
```text
vault read auth/approle/role/my-role/role-id
```
Generate Secret ID
```text
vault write -f auth/approle/role/my-role/secret-id
```
Login using AppRole
```text
vault write auth/approle/login role_id="..." secret_id="..."
```
❌ Issue: failed to determine alias name
Root Cause:
ROLE_ID or SECRET_ID empty or incorrect
Fix:
```text
echo $ROLE_ID
echo $SECRET_ID
```
OR fetch correctly:
```text
vault read -field=role_id auth/approle/role/my-role/role-id
vault write -field=secret_id -f auth/approle/role/my-role/secret-id
```
🔑 8. Token Usage

After login, Vault returns:
```text
token: hvs.xxxxx
```
Use token directly (no env variable)
```text
vault kv get -token="hvs.xxxxx" trial/myapp
```
Better way (interactive login)
```text
vault login
```

Paste token → CLI stores it locally

🌐 9. SSH Tunneling (Your Setup)
```text
ssh -L 8200:127.0.0.1:8200 ubuntu@EC2-IP
```
Terraform uses:
```text
address = "http://127.0.0.1:8200"
```
👉 Correct because tunnel maps local → remote Vault

⚙️ 10. Terraform Integration
```text
Provider
provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "hvs.xxxxx"
}
```
Read secret (OLD - deprecated)
```text
data "vault_kv_secret_v2" "secret" {
  mount = "trial"
  name  = "myapp"
}
```
❌ Issue: Deprecated Warning
```text
Deprecated. Please use new Ephemeral KVV2 Secret resource
```
✅ 11. New Pattern (Ephemeral Secrets)
```text
ephemeral "vault_kv_secret_v2" "secret" {
  mount = "trial"
  name  = "myapp"
}
```
Usage
```text
output "username" {
  value     = ephemeral.vault_kv_secret_v2.secret.data["username"]
  sensitive = true
}
```
🧠 Why Ephemeral?
Old	New
```text
Stored in state ❌	Not stored ✅
Persistent	Runtime only
Security risk	Secure
```
❌ 12. Terraform Error (403)
```text
failed to create limited child token
```
Root Cause:

Terraform needs:
```text
path "auth/token/create" {
  capabilities = ["update"]
}
```
Fix policy:
```text
path "auth/token/create" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}
```
🔍 13. Sensitive Output Issue
```text
sensitive = true
```
Output:
```text
<sensitive>
```
Solution:
```text
terraform output -raw username
```
⚠️ Important Security Notes
❌ Don’t do this in production:
```text
token = "hvs.xxxxx"
```
✅ Use AppRole instead
```text
provider "vault" {
  address = "http://127.0.0.1:8200"

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "xxxx"
      secret_id = "xxxx"
    }
  }
}
```

---

👨‍💻 **Author**

**Reuben**
**DevOps / Cloud Enthusiast 🚀**