resource "tls_private_key" "aks_ssh" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "local_file" "private_key" {
  content         = tls_private_key.aks_ssh.private_key_pem
  filename        = "${path.module}/../../keys/${var.key_name}"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content         = tls_private_key.aks_ssh.public_key_openssh
  filename        = "${path.module}/../../keys/${var.key_name}.pub"
  file_permission = "0644"
}