!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
# sudo systemctl status nginx

# Install to pass test
# sudo apt-get install nodejs -y
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2 -g -y
# systemctl status nginx

#cd /home/vagrant/
#sudo echo export DB_HOST="mongodb://192.168.10.150:27017/posts" >> ~/.bashrc
#source ~/.bashrc


cd /sync_folder/app/
npm install -y
# npm start



