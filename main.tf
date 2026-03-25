provider "aws" {
  region = "us-east-1"
}

# Generate random password for RDS (no special chars that conflict with MySQL)
resource "random_password" "db_password" {
  length  = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "networking" {
  source = "./modules/networking"
}

module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
}

module "compute" {
  source = "./modules/compute"

  vpc_id           = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  target_group_arn = module.load_balancer.target_group_arn
  alb_sg_id        = module.load_balancer.alb_sg_id
}

module "database" {
  source = "./modules/database"

  vpc_id           = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  compute_sg_id    = module.compute.security_group_id
  db_password      = random_password.db_password.result
}
