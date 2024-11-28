provider "aws" {
    region = "us-east-2"
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress = [
        {
            description = "HTTP"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        },
        {
            description = "SSH"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ]

    egress = [
        {
            description = "Outbound"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
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
              # Update system packages
              yum update -y 
              # Install Apache web server 
              yum install -y httpd 
              # Start and enable Apache service
              systemctl start httpd
              systemctl enable httpd 
              # Create a basic index.html file
              echo "<h1>Hello from AWS!</h1>" > /var/www/html/index.html
              EOF

    user_data_replace_on_change = true
    tags = {
        Name = "terraform-example"
    }
}
