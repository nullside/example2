/*
  Web Servers
*/
resource "aws_security_group" "web" {
  name = "vpc_web"
  description = "Allow incoming HTTP connections."

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cider}"]
  }
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cider}"]
  }

  egress { # SQL Server
    from_port = 1433
    to_port = 1433
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  egress { # MySQL
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "WebServerSG"
  }
}

resource "aws_instance" "web-1" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "us-west-1"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${aws_subnet.us-west-1-public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "Web Server 1"
  }
}

resource "aws_eip" "web-1" {
  instance = "${aws_instance.web-1.id}"
  vpc = true
}