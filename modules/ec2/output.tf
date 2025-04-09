output "proxy_instance_ids" {
  value = aws_instance.proxy[*].id
}

output "apache_instance_ids" {
  value = aws_instance.apache[*].id
}

output "proxy_public_ips" {
  value = aws_instance.proxy[*].public_ip
}

output "apache_private_ips" {
  value = aws_instance.apache[*].private_ip
}
