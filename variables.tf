variable "aws_region" {
    default = "us-east-1"
}

variable "bucket_name" {
    default = "test-log-nginx-kr"
}

variable "vpc_name" {
    default = "vpc-dev"
}

variable "cidr_vpc" {
    default = "10.18.0.0/16"
}

variable "cidr_subnet" {
    default = "10.18.1.0/24"
}

variable "subnet_name" {
    default = "public"
}

variable "subnet_az" {
    default = "us-east-1a"
}


variable "ig_name" {
    default = "IG-dev"
}

variable "acl_name" {
    default = "dev"
}

variable "public_acl_inbound_tcp_ports" {
  default     = ["80", "443"]
}

variable "sg_name" {
    default = "dev"
}

variable "nic_name" {
    default = "primary-dev"
}

variable "subnet_private_ip" {
    default = "10.18.1.10"
}

variable "instance_ami" {
    default = "ami-07d02ee1eeb0c996c"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "instance_volume_size" {
    default = "20"
}

variable "instance_volume_type" {
    default = "gp2"
}

variable "instance_name" {
    default = "nginx"
}