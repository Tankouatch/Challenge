#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
sudo systemctl start nginx
sudo bash -c 'echo "Welcome to Nginx" > /var/www/html/index.html'
