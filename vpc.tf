resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cider}"
  enable_dns_hostnames = true
  tags {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "InternetGateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id = "${var.public_subnet_cider}"
  depends_on = ["aws_internet_gateway.default"]
}

/*
Public Subnet
*/
resource "aws_subnet" "us-west-1-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.public_subnet_cider}"
  availability_zone = "us-west-1"

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "us-west-1-pub" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "${aws_vpc.default.id}"
  }

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "us-west-1-public" {
  subnet_id = "${aws_subnet.us-west-1-public.id}"
  route_table_id = "${aws_route_table.us-west-1-pub.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-west-1-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-west-1"

  tags {
    Name = "priv sub"
  }
}

resource "aws_route_table" "us-west-1priv" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "private_route" {
  route_table_id = "${aws_route_table.us-west-1priv.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat.id}"
}

resource "aws_route_table_association" "us-west-1priv" {
  subnet_id = "${aws_subnet.us-west-1-private.id}"
  route_table_id = "${aws_route_table.us-west-1priv.id}"
}
