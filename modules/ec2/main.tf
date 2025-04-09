# -------------------------------
# 1. Proxy EC2 Instances (Public)
# -------------------------------

resource "aws_instance" "proxy" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.public_subnet_ids, count.index)
  key_name      = var.key_name
  vpc_security_group_ids = [var.proxy_sg_id]

  associate_public_ip_address = true

  tags = {
    Name = "proxy-ec2-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y nginx",
      "echo 'server { listen 80; location / { proxy_pass http://${var.private_alb_dns}; } }' | sudo tee /etc/nginx/conf.d/reverse.conf",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

resource "null_resource" "write_proxy_ips" {
  provisioner "local-exec" {
    command = <<EOT
echo "public-ip0 ${aws_instance.proxy[0].public_ip}" > all-ips.txt
echo "public-ip1 ${aws_instance.proxy[1].public_ip}" >> all-ips.txt
EOT
  }

  depends_on = [aws_instance.proxy]
}


# -----------------------------------
# 2. Apache EC2 Instances (Private)
# -----------------------------------

resource "aws_instance" "apache" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnet_ids, count.index)
  key_name      = var.key_name
  vpc_security_group_ids = [var.apache_sg_id]

  associate_public_ip_address = false

  tags = {
    Name = "apache-ec2-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y httpd",
      "echo '<h1>Apache Host ${count.index}</h1>' | sudo tee /var/www/html/index.html",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.private_ip


      bastion_host        = aws_instance.proxy[0].public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)

    }
  }
}
