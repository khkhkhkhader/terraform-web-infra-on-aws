# Creat S3 bucket for backend
resource "aws_s3_bucket" "my-backend-bucket" {
  bucket = "my-be-bucket-for-backend"

  tags = {
    Environment = "test"
  }
}

module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}


module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "keypair" {
  source   = "./modules/keypair"
  key_name = "lab3-key"
}


data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]  

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "ec2" {
  source              = "./modules/ec2"
  ami_id              = data.aws_ami.latest_amazon_linux.id
  key_name            = module.keypair.key_name
  private_key_path    = module.keypair.private_key_path
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  proxy_sg_id         = module.security.proxy_sg_id
  apache_sg_id        = module.security.apache_host_sg_id
  private_alb_dns     = module.loadbalancers.private_alb_dns
  

}


module "loadbalancers" {
  source              = "./modules/loadbalancers"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  alb_public_sg_id    = module.security.alb_public_sg_id
  alb_private_sg_id   = module.security.alb_private_sg_id
  proxy_instance_ids  = module.ec2.proxy_instance_ids
  apache_instance_ids = module.ec2.apache_instance_ids
}
