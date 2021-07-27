!#/bin/bash

# mongodb keys
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927 
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update -y
sudo apt-get upgrade -y

# Install mongod and multiple packages
sudo apt-get install -y --allow-downgrades mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20

# Change bindIp line with line new line
cd /etc
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' mongod.conf

# To restart and enable changes
cd
sudo systemctl restart mongod
sudo systemctl enable mongod


