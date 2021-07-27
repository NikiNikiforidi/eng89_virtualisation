!#/bin/bash 


# In VM, Update/ Upgrade source list 
sudo apt-get update -y
sudo apt-get upgrade -y

# install git
sudo apt-get install git -y

# Install bundler
gem install bundler

# Install nodejs (v6) and npm to pass spec-test
sudo apt-get install nodejs -y
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2 -g -y


# Install nginx
sudo apt-get install nginx -y

cd
# Install npm in specific directon location
cd /home/vagrant/sync_folder/app

sudo npm install -y
 

cd
# Deleteing default nginx file and adding new file
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
" >>default


# Chech nginx conf. and restart to solidify changes
sudo nginx -t
sudo systemctl restart nginx



# Creating persistant variable
cd
cd /home/vagrant
export DB_HOST="mongodb://192.168.10.150:27017/posts" >> ~/.bashrc
source ~/.bashrc

#cd /home/vagrant/sync_folder/app
