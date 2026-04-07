## public subnets route table
resource "aws_route_table" "public_rt_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name         = "${var.env}-public-route-table"
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
  "service" = "infra" }
}

resource "aws_route" "public_rt_01" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_01.id
  route_table_id         = aws_route_table.public_rt_01.id
}

resource "aws_route_table_association" "public_rt_as_01" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subs_01.*.id, count.index)
  route_table_id = aws_route_table.public_rt_01.id
}

resource "aws_main_route_table_association" "public_rt_main_as_01" {
  vpc_id         = aws_vpc.vpc_01.id
  route_table_id = aws_route_table.public_rt_01.id
}

## private route table
resource "aws_route_table" "private_rt_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name         = "${var.env}-private-route-table"
    "account"    = var.env
    "owner"      = "techops"
    "management" = "terraform"
  "service" = "infra" }
}

resource "aws_route" "private_rt_01" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_01.0.id
  route_table_id         = aws_route_table.private_rt_01.id
}

resource "aws_route_table_association" "private_data_rt_as_01" {
  count          = 3
  subnet_id      = element(aws_subnet.private_data_subs_01.*.id, count.index)
  route_table_id = aws_route_table.private_rt_01.id
}
