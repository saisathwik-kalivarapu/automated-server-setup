#!/bin/bash
echo "automated server provisioning"
echo "1/5 installing NGINX"
sudo apt update
sudo apt install -y nginx
echo "Nginx has been installed"
echo "2/5 configuring deployment user"
if id "deployer" &>/dev/null; then
	echo "deployer already exists"
else
	sudo useradd -m -s /bin/bash deployer
	echo "deployer created"
fi
echo "3/5 configuring the firewall"
echo "The current status is $(sudo ufw status)"
sudo ufw allow 80/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable
echo "The current status is $(sudo ufw status)"
echo "4/5 starting the NGINX server and deploying the website"
echo "NGINX version is $(nginx -v)"
sudo systemctl enable --now nginx
sudo cp website/index.html /var/www/html/index.html
echo "website has been deployed"
echo "5/5 verification"
nginx -v
systemctl is-active nginx
sudo ufw status
id deployer
curl http://localhost