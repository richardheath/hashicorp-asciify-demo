resource "aws_iam_role" "server" {
  name = "demo-nomad-server"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "server" {
  name = "demo-nomad-server"
  role = "${aws_iam_role.server.name}"
}

resource "aws_iam_role_policy" "server" {
  name = "demo-nomad-server-policy"
  role = "${aws_iam_role.server.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
