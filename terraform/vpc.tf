data "aws_availability_zones" "available" { state = "available" }

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "oneclick-vpc" }
}

locals { azs = slice(data.aws_availability_zones.available.names, 0, 2) }

resource "aws_subnet" "public" {
  count = length(local.azs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "oneclick-public-${count.index}" }
}

resource "aws_subnet" "private" {
  count = length(local.azs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = false
  tags = { Name = "oneclick-private-${count.index}" }
}
