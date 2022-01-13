locals {
  tags = {
    ManagedBy = "Terraform"
  }
}

resource "random_shuffle" "ec2_subnet_ids" {
  input        = var.ec2_subnet_ids
  result_count = 1
}

resource "aws_security_group" "this" {
  name        = "${var.name}-openvpn"
  description = "${var.name}-openvpn"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 1194
    to_port          = 1194
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    {
      "Name" = "${var.name}-openvpn"
    },
    local.tags
  )
}

resource "aws_iam_role" "this" {
  name = "${var.name}-openvpn"
  path = "/"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF

  inline_policy {
    name   = "${var.name}-openvpn"
    policy = <<-EOF
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "cloudwatch:PutMetricData",
              "ec2:DescribeVolumes",
              "ec2:DescribeTags",
              "logs:PutLogEvents",
              "logs:DescribeLogStreams",
              "logs:DescribeLogGroups",
              "logs:CreateLogStream"
            ],
            "Resource": "*"
          }
        ]
      }
      EOF
  }

  tags = merge(
    {
      "Name" = "${var.name}-openvpn"
    },
    local.tags
  )
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-openvpn"
  role = aws_iam_role.this.name

  tags = merge(
    {
      "Name" = "${var.name}-openvpn"
    },
    local.tags
  )
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  iam_instance_profile   = aws_iam_instance_profile.this.id
  instance_type          = var.instance_type
  subnet_id              = random_shuffle.ec2_subnet_ids.result[0]
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = merge(
    {
      "Name"   = "${var.name}-openvpn"
    },
    local.tags
  )

  volume_tags = merge(
    {
      "Name"   = "${var.name}-openvpn"
    },
    local.tags
  )
}
