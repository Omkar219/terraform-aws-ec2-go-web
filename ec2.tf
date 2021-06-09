

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "myKey1"       # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey1.pem"
  }
}

data "template_file" "myuserdata" {
  template = "${file("${path.cwd}/myuserdata.tpl")}"
}

resource "aws_instance" "web" {
  count = 2 
  ami = "ami-04bde106886a53080"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  security_groups   = ["${aws_security_group.allow_from_my_ip.name}"]
  #user_data = "${data.template_file.myuserdata.rendered}"
  user_data = data.template_file.myuserdata.template

  tags = {
    Name = "Nginx_web_server"
  }
}




  data "template_file" "myuserdata_alb" {
    template = "${file("${path.cwd}/myuserdata_alb.tpl")}"
    vars = {
      private_ip1 = aws_instance.web[0].private_ip

      private_ip2 = aws_instance.web[1].private_ip


    }
  }

resource "aws_instance" "alb" {
  count = 1
  ami = "ami-04bde106886a53080"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  security_groups   = ["${aws_security_group.allow_from_my_ip.name}"]
  user_data = data.template_file.myuserdata_alb.template
  tags = {
    Name = "Nginx_alb_server"
  }
  depends_on = []
}
