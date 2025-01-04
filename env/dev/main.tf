##Provider for ap-northeast-1
provider "aws" {
  profile    = "terraform-user"
  #access_key = var.access_key
  #secret_key = var.secret_key
  region     = "ap-northeast-1"
}

##Network
module "network" {
  source = "../../module/network"

  general_config      = var.general_config
  availability_zones  = var.availability_zones
  vpc_id              = module.network.vpc_id
  vpc_cidr            = var.vpc_cidr
  internet_gateway_id = module.network.internet_gateway_id
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
}

##Security Group Internal
module "internal_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_blocks    = ["10.0.0.0/16"]
  sg_role        = "internal"
}

##Secutiry Group Operation
module "operation_sg_1" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_1_cidr
  sg_role        = "operation_1"
}

module "operation_sg_2" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_2_cidr
  sg_role        = "operation_2"
}

module "operation_sg_3" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_3_cidr
  sg_role        = "operation_3"
}

module "alb_http_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  cidr_blocks    = ["0.0.0.0/0"]
  sg_role        = "alb_http"
}

##EC2
module "ec2" {
  source = "../../module/ec2"

  general_config    = var.general_config
  ec2_count         = var.ec2_count
  ami               = var.ami
  public_subnet_ids = module.network.public_subnet_ids
  internal_sg_id    = module.internal_sg.security_group_id
  operation_sg_1_id = module.operation_sg_1.security_group_id
  operation_sg_2_id = module.operation_sg_2.security_group_id
  operation_sg_3_id = module.operation_sg_3.security_group_id
  instance_type     = var.instance_type
  volume_type       = var.volume_type
  volume_size       = var.volume_size
}

##ALB
module "alb" {
  source = "../../module/alb"

  vpc_id                   = module.network.vpc_id
  general_config           = var.general_config
  public_subnet_ids        = module.network.public_subnet_ids
  alb_http_sg_id           = module.alb_http_sg.security_group_id
  instance_ids             = module.ec2.instance_ids
}