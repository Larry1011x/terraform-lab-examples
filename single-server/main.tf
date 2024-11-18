provider "aws" {
    region = "us-east-2"
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress = [
        {
            description = "HTTP"
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ]
}

resource "aws_instance" "example" {
    ami = "ami-0942ecd5d85baa812"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.instance.id ]

    user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

    user_data_replace_on_change = true
    tags = {
        Name = "terraform-example"
    }
}
