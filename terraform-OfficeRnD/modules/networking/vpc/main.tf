resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.client_name}-${var.environment}"
  }
}

resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_ig.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "default" {
  depends_on = [aws_internet_gateway.vpc_ig]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_key_pair" "bastion_key" {
#  count = var.create_key_pair ? 1 : 0

  key_name        = var.key_name
  public_key      = var.public_key
}

resource "aws_instance" "Bastion" {
  ami                         = "ami-0ec28fc9814fce254"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.bastion_key.id
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "Bastion"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion_sg"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_ssh_inbound_bastion" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion_sg.id

  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  cidr_blocks              = ["95.111.37.67/32"]
}

resource "aws_security_group_rule" "allow_all_outbound_bastion" {
  type              = "egress"
  security_group_id = aws_security_group.bastion_sg.id

  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

