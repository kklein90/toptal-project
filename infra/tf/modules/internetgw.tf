resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name         = "${var.env}-igw"
    "owner"      = "techops"
    "management" = "terraform"
    "service"    = "infra"
  }
}
