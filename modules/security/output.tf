output "alb_public_sg_id" {
  value = aws_security_group.alb_public_sg.id
}

output "proxy_sg_id" {
  value = aws_security_group.proxy_sg.id
}

output "alb_private_sg_id" {
  value = aws_security_group.alb_private_sg.id
}

output "apache_host_sg_id" {
  value = aws_security_group.apache_host_sg.id
}
