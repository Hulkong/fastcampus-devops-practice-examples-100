################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.prefix
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  private_subnets = concat(
    [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 4)],
    [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 8)]
  )
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 48)]

  public_subnet_names = [for k, v in local.azs : join(":", [join("-", [local.prefix, "subnet", "public", "net"]), v])]
  private_subnet_names = concat(
    [for k, v in local.azs : join(":", [join("-", [local.prefix, "subnet", "private", "net"]), v])],
    [for k, v in local.azs : join(":", [join("-", [local.prefix, "subnet", "private", "eks"]), v])]
  )
  database_subnet_names = [for k, v in local.azs : join(":", [join("-", [local.prefix, "subnet", "private", "data"]), v])]

  create_database_subnet_group  = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = local.nat_gateway.enabled
  single_nat_gateway     = local.nat_gateway.enabled && !local.nat_gateway.per_az
  one_nat_gateway_per_az = local.nat_gateway.enabled && local.nat_gateway.per_az

  enable_vpn_gateway = false

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "ap-northeast-2.compute.internal"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log = false

  tags                    = local.tags
  vpc_tags                = { Name : join("-", [local.prefix, "vpc"]) }
  public_route_table_tags = { Name : join("-", [local.prefix, "rt", "public", "net"]) }
  dhcp_options_tags       = { Name : join("-", [local.prefix, "dhcp"]) }
}
