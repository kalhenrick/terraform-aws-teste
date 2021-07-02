resource "aws_security_group" "sec" {
  name        = var.sg_name
  vpc_id      = aws_vpc.dev.id

  tags = {
    Name = "SG ${var.sg_name}"
  }
}

resource "aws_security_group_rule" "in" {
  count          = length(var.public_acl_inbound_tcp_ports)
  description       = "Allow traffic to EC2"
  type              = "ingress"
  from_port         = var.public_acl_inbound_tcp_ports[count.index]
  to_port           = var.public_acl_inbound_tcp_ports[count.index]
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sec.id
}

resource "aws_security_group_rule" "all_from_ec2_nodes_world" {
  description       = "Traffic to internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sec.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_network_interface" "nic" {
  subnet_id   = aws_subnet.public.id
  private_ips = list(var.subnet_private_ip)
  security_groups = [aws_security_group.sec.id]
  tags = {
    Name = var.nic_name
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/install-nginx.sh")

  vars = {
    bucket_name = aws_s3_bucket.bucket.bucket
  }
}


resource "aws_instance" "instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  monitoring = true

  iam_instance_profile = aws_iam_instance_profile.ec2.name
  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.instance_volume_size
    volume_type = var.instance_volume_type
    encrypted = false
  }

  user_data_base64 = "${base64encode(data.template_file.userdata.rendered)}"

  tags = {
    "Name" = var.instance_name
  }

}

resource "aws_eip" "elastic_public_ip" {
  vpc = true

  instance                  = aws_instance.instance.id
  associate_with_private_ip = var.subnet_private_ip
  depends_on                = [aws_internet_gateway.dev]
}