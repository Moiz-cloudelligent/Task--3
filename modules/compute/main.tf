# -------------------------
# SECURITY GROUP FOR INSTANCES
# -------------------------
resource "aws_security_group" "instance_sg" {
  name        = "${var.name_prefix}-instance-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-instance-sg"
  }
}

# -------------------------
# EC2 INSTANCES
# -------------------------
resource "aws_instance" "app" {
  count                = var.instance_count
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = var.instance_type
  subnet_id            = var.private_subnets[count.index % length(var.private_subnets)]
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {
    instance_number = count.index + 1
  }))

  tags = {
    Name = "${var.name_prefix}-instance-${count.index + 1}"
  }
}

# -------------------------
# TARGET GROUP ATTACHMENT
# -------------------------
resource "aws_lb_target_group_attachment" "app" {
  count            = var.instance_count
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}

# -------------------------
# DATA SOURCE FOR AMI
# -------------------------
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
