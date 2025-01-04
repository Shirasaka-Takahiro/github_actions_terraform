##Private Key
resource "tls_private_key" "default" {
  algorithm = var.key_algorithm
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
    key_name = "${var.general_config["project"]}-${var.general_config["env"]}_rsa_key"
    public_key = tls_private_key.default.public_key_openssh

    tags = {
        Name = "${var.general_config["project"]}-${var.general_config["env"]}_rsa_key"
    }
}