!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y


# Install to pass test
sudo apt-get install nodejs -y
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2 -g -y


#cd /home/vagrant/
#sudo echo export DB_HOST="mongodb://192.168.10.150:27017/posts" >> ~/.bashrc
#source ~/.bashrc


cd /sync_folder/app/
npm install -y
# npm start



cd /etc/nginx/sites-available
sudo rm -rf default
sudo echo "

server {
    listen 80;

    server_name _;
    location / {
        proxy_pass http://192.168.10.100:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
#test

" >>default
sudo nginx -t
sudo systemctl restart nginx
