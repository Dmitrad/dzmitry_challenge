#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo echo "<h1> Hello World </h1>" > /var/www/html/index.html
# sudo mkdir /var/www/html/images 
# sudo chmod 777 /var/www/html/images
# sudo echo "<h1> TEAMS2 - IMAGES </h1>" > /var/www/html/images/index.html





# sudo yum update -y
# sudo yum install -y httpd
# sudo systemctl start httpd.service
# # sudo systemctl enable httpd.service
# sudo echo "<h1> At $(hostname -f) </h1> IMAGES"> /var/www/html/images/index.html
