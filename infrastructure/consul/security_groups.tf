resource "aws_security_group" "server" {
  name        = "demo-consul-server"
  description = "sec group used to demo consul connect"
  vpc_id      = "${var.vpc_id}"
  tags        = "${var.tags}"

  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    description = "Server RPC"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    description = "Serf LAN"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    description = "Serf LAN"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    description = "Serf WAN"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "udp"
    description = "Serf WAN"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    description = "CLI RPC"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    description = "HTTP API"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    description = "DNS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    description = "DNS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.22.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "server-lb" {
  name        = "demo-consul-server-lb"
  description = "sec group used to demo consul connect"
  vpc_id      = "${var.vpc_id}"
  tags        = "${var.tags}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
