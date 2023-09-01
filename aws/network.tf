module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "${var.aws_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway      = true
  map_public_ip_on_launch = true

  tags = local.tags
}

resource "aws_security_group" "default" {
  name        = "${var.aws_prefix}-default-sg"
  description = "Default security group allowing egress only"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "all_ingress_from_deployers_ip" {
  for_each = {
    ssh          = 22
    containerssh = 2222
  }

  type              = "ingress"
  description       = "TLS"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.deployer_ip.response_body}/32"]
  security_group_id = aws_security_group.default.id
}
