variable "aws_region" {
  default = "eu-central-1"
}

variable "amd_64_eu_central_1_debian_ami" {
  default = "ami-08f13e5792295e1b2"
}

variable "amd_64_eu_central_1_amazon_linux_2_ami" {
  default = "ami-0adbcf08fdd664fed"
}

variable "public_subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  type    = string
  default = "eu-central-1a"
}
