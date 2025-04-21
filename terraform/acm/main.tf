# AWS Certificate Manager resources for demo project (self-signed)

# Generate private key for self-signed certificate
resource "tls_private_key" "cert" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate self-signed certificate
resource "tls_self_signed_cert" "cert" {
  private_key_pem = tls_private_key.cert.private_key_pem

  subject {
    common_name  = var.certificate_common_name
    organization = "Cloud Project Organization"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Import the self-signed certificate to ACM
resource "aws_acm_certificate" "main" {
  private_key      = tls_private_key.cert.private_key_pem
  certificate_body = tls_self_signed_cert.cert.cert_pem

  tags = {
    Name        = "${var.environment}-demo-certificate"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
