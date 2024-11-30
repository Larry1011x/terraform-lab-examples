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
