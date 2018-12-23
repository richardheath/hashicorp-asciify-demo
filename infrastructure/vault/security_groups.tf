resource "aws_security_group" "server" {
  name        = "demo-vault-server"
  description = "sec group used to demo vault connect"
  vpc_id      = "${var.vpc_id}"
  tags        = "${local.tags}"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    description = "Server API"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    description = "cluster address"
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
