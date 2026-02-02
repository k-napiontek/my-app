# 4. Wystawiamy klucz PUBLICZNY, żebyś mógł go dodać do GitHub
output "github_public_key" {
  value = tls_private_key.git_deploy_key.public_key_openssh
}