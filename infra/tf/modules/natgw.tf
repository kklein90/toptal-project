resource "aws_eip" "nat_eip" {}

# Create NAT gateway for private subnets
resource "aws_nat_gateway" "nat_gw_01" {
  count             = 1
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = element(aws_subnet.public_subs_01.*.id, count.index)
  depends_on        = [aws_internet_gateway.igw_01]

  tags = {
    Name         = "${var.env}-natgw"
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}
