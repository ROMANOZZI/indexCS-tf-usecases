## Generating Key Pair
## private key generation
# 1- create the private key
resource "tls_private_key" "index_private_key"{
  algorithm = "RSA"
  rsa_bits = 4096

}
# 2- save the private key into local file
resource "local_file" "index_key_file" {
  filename = "index_ec2_key.pem"
  content = tls_private_key.index_private_key.public_key_pem
  file_permission = "0400"
  
}

# 3- Import Public Key into aws
resource "aws_key_pair" "index_key_pair" {
  key_name = var.key_name
  public_key = tls_private_key.index_private_key.public_key_openssh
}


