data "aws_ami" "amazon_linux_free_tier" {
  most_recent = true
  owners = [
    "amazon"
  ]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2"
    ]
  }
}

data "aws_vpc" "default_vpc" {
  filter {
    name = "is-default"
    values = [
      true
    ]
  }
}
