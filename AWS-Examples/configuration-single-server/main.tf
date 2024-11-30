provider "aws" {
    region = "us-east-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 80

}

output "public_ip" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}

resource "aws_security_group" "terraform-example-instance" {
    name = "terraform-example-instance"

    ingress = [
        {
            description = "HTTP"
            from_port = var.server_port
            to_port = var.server_port
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
    vpc_security_group_ids = [ aws_security_group.terraform-example-instance.id ]

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
