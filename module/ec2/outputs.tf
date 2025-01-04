output "instance_ids" {
  value = aws_instance.web.*.id
}

output "aws_key_pair_public_key" {
  value = tls_private_key.default.public_key_openssh
}

output "aws_key_pair_private_key" {
  value = tls_private_key.default.private_key_pem
}