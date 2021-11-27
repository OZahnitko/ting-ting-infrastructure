resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "Deployer Key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "ting_ting_sg" {
  description = "Fairly loose security group."
  name        = "Ting Ting SG"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress = [
    {
      description      = "All Incoming Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "All Outgoing Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "Ting Ting SG"
  }
}

resource "aws_instance" "ting_ting" {
  ami           = data.aws_ami.amazon_linux_free_tier.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [
    aws_security_group.ting_ting_sg.id
  ]

  provisioner "remote-exec" {
    inline = [
      "echo ${tls_private_key.ssh_key.private_key_pem} > trust_me.txt"
    ]
  }

  connection {
    host        = self.public_ip
    private_key = tls_private_key.ssh_key.private_key_pem
    type        = "ssh"
    user        = "ec2-user"
  }

  tags = {
    Name = "Ting Ting"
  }
}
