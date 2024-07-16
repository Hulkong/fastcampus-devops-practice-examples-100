locals {
  name     = "part03-07-senario"
  region   = "us-west-2"
  vpc_cidr = "10.2.0.0/16"

  env                 = "dev"
  prefix              = join("-", [local.name, local.env])
  prod_domain         = "hulkong.shop"
  domain              = "${local.env}.${local.prod_domain}"
  azs                 = slice(data.aws_availability_zones.available.names, 0, 4)
  git_private_ssh_key = var.ssh_key_path # Update with the git ssh key to be used by ArgoCD
  eks = {
    kms = false
  }
  nat_gateway = {
    enabled = true
    per_az  = false
  }

  argocd_project_administration = join("-", [local.name, local.env, "administration"])
  argocd_project_workload       = join("-", [local.name, local.env, "workload"])

  tags = {
    Env       = local.prefix
    ManagedBy = "terraform"
  }
}
