# Setting up Development Env
## Monday 12th, Installation of Vagran and setting up virtual box and Ruby
### Vagrant Commands
- `vagrant init` creates a new vagrantfile in a directory
- `vagrant up` to launch the vm
- `vagrant destroy` to delete everything
- `vagrant reload` to reload any new instructions in our `Vagrantfile`
- `vagrant halt` it pauses the
- `vagrant status` 
**`vagrant` shows a list of commands:**

```
   autocomplete    manages autocomplete installation on host
     box             manages boxes: installation, removal, etc.
     cloud           manages everything related to Vagrant Cloud
     destroy         stops and deletes all traces of the vagrant machine
     global-status   outputs status Vagrant environments for this user
     halt            stops the vagrant machine
     help            shows the help for a subcommand
     init            initializes a new Vagrant environment by creating a Vagrantfile
     login
     package         packages a running vagrant environment into a box
     plugin          manages plugins: install, uninstall, update, etc.
     port            displays information about guest port mappings
     powershell      connects to machine via powershell remoting
     provision       provisions the vagrant machine
     push            deploys code in this environment to a configured destination
     rdp             connects to machine via RDP
     reload          restarts vagrant machine, loads new Vagrantfile configuration
     resume          resume a suspended vagrant machine
     snapshot        manages snapshots: saving, restoring, etc.
     ssh             connects to machine via SSH
     ssh-config      outputs OpenSSH valid configuration to connect to the machine
     status          outputs status of the vagrant machine
     suspend         suspends the machine
     up              starts and provisions the vagrant environment
     upload          upload to machine via communicator
     validate        validates the Vagrantfile
     version         prints current and latest Vagrant version
     winrm           executes commands on a machine via WinRM
     winrm-config    outputs WinRM configuration to connect to the machine
```
- More info at: https://www.vagrantup.com/
- To get info about the VM, run `uname -a`
- -------------------------------------------------------------
**Reload/Destroy vagrant**
- `vagrant reload` reloads vagrant 
- If this does not work, you will have to:
```
vagrant destroy
vagrant up 
vagrant ssh 
```
- -------------------------------------------------------------------------------------------------------
### Additional information and commands

- Let's `ssh` into our VM and launch nginx web-server
- `apt-get` is used to install/uninstall any packages 
- To use the command in `admin` mode we use `sude` before the command, Example (in your VM)
```
sudo apt-get upgrade -y
sudo apt-get update -y
sudo apt-get install name_of_package
```
- ------------------------------------------------------------------------
### Installing and running nginx manually
- Run following code in VM to install and check status of bginx
```
 sudo apt-get update -y
 sudo apt-get upgrade -y
 sudo apt-get install nginx
 sudo systemctl status nginx
  ```
  **in order to see nginx in our browser, we need to connect it with a private ip** 

- In vagrant file add,`config.vm.network "private_network", ip: "192.168.10.100"`
- (load ip using host machine browser to view default nginx page)
- ningx status active should load nginx in the browswer with 192.168.10.100 

- ------------------------------------------------------------
**To replace ip in browser with something more user friendly**
<br></br>
- This is not a necessary step for code functionality
- Install plugin in OS: `vagrant plugin install vagrant-hostsupdater`
- In Vagrantfile add, `config.hostsupdater.aliases = ["development.locat"]` 
- Reload or destroy vagrant to save alterations
- Go to browser and write: http://development.local/

- ---------------------------------------------------- 

### Introduction to provision

- Create a file called `provision.sh` and add below code
- Create file `sudo nano provision.sh`
```
#!/bin/bash
sudo apt-get update -y
sude apt-get upgrade -y
sudo apt-get install nginx -y
```
- When creating an automated file, make sure you write `-y` at the end of the line
<br></br>
- To run provision.sh we need to give file permission and make this file exceutable.
- In VM, to run provision.sh, run: `sudo chmod +x provision.sh`
- chmod changes permission
- The file turns green when changed.
- To run file run `sudo ./provision.sh`
- What ever is in your provision file will automatically run and install
- --------------------------------------------
**Extra**
- Run `top` to display every proccess running
- `ps aux` everything running in the foreground
- To manually kill process `sudo kill process_id` 
- -----------------------------------
## Tuesday  13, Automating provision and syncing folders

**Added app and environment folder to our directory**
<br></br>
- Create provision.sh in OS (environment folder) and add below code:
```
!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
```
- To run the provision file automatically, you'll need to connect it from within the Vagrantfile with:
` config.vm.provision "shell", path:"./environment/provision.sh" `
<br> </br>

**Syncing folders**
- To sync local host file (provision.sh) to VM, add below code in vagrantfile :
- If you want to sync everything from current location of Vagrantfile, replace the host path with a dot .

```
config.vm.synced_folder ".", "/home/vagrant/sync_folder"
```
- The first parameter is a path to a directory on the host machine.
- The second parameter must be an absolute path of where to share the folder within the guest machine.
- Destroy and reload VM to check if nginx installed (sudo systemctl status nginx) and sync folders have worked (in VM, check with ls)
<br> </br>
-The order of the sync and provision file in Vagrantfile, are important
- -----------------------------------------------

### Spec Tests

- To locate spec-tests/, on OS go to environment -> spec-test file and enter:
```
gem install bundler # To install necessary bundles
```
- Make sure to be in the spec-test folder in OS to run tests
```
rake spec
```
- 3 tests failed. nodejs, nodejs --version and pm2

**Installing missing packages (in VM)**
<br></br>
- To install nodejs
```
sudo apt-get install nodejs -y
```
- To install nodejs --version(run each line seperatly) 
```
sudo apt-get install python-software-properties -y
```
```
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
```
- and then:
```
sudo apt-get install nodejs -y
```
- Finally, to install pm2 
```
sudo npm install pm2 -g
```
- Run spec-tests in OS and all should pass
<br> </br>
**Add installation steps to provision.sh folder**
**Current provision folder:**
```
!#/bin/bash 

# In VM, Update/ Upgrade source list
sudo apt-get update -y
sudo apt-get upgrade -y


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

# Install npm in specific directory location
cd /sync_folder/app/
npm install -y
npm start


```
- ------------------------------------------------------------------
### Launch Sparta Global app
- If everything has installed correctly, you should run below line in the VM -> sync_folder ->app folder:
```
node app.js

```
**OR**
```
npm start
```
- You should get a message that says: Your app is ready and listening on port 3000
<br> </br>

- If you open your browser and type the ip and pord(http://192.168.10.100:3000/) and should get a Sparta Global welcom page.
- Additionally, if you type this (http://192.168.10.100:3000/fibonacci/6) in the browser ypu should get another page that returns the fibonacci number of 6. Note: it doesn't have to be the number 6, can be anythingls
<br></br>
**Current Vagrantfile:**
```
Vagrant.configure("2") do |config|
  
 config.vm.box = "ubuntu/xenial64"
  #using ubuntu 16.04 LTS box
  
 #  let's connect to nginx using private ip
    config.vm.network "private_network", ip: "192.168.10.100"
 #  we would like to load this ip using our host machine's browser
 #  to view default nginx page
   
    config.hostsupdater.aliases = ["development.local"]
    # if the plugin is installed correctly and file is update with vagrant destroy then vagrant up
    # we should be able to see nginx page in the browser with http://development.local 



    config.vm.synced_folder ".", "/home/vagrant/sync_folder"
    # If you want to sync everything from current location of vagrant file, replace the whole path with a dot .
    # config.vm.synced_folder '.', "/home/vagrant/environment"
    
    # Find provision.sh file and run it (once the files have synced)
    config.vm.provision "shell", path:"./environment/provision.sh"
end

```
- --------------------------
## Wednesday 14th, Reverse proxy
<br> </br>
- We are going to change the nginx default page to the app welcome page
<br> </br>

- In VM, open /etc/nginx/sites-available (defualt file available)
- Edit default file `sudo nano default`
- Delete everything and update with :
```
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

```
- To check configuration `sudo nginx -t` 
- Will return a success message if correct syntax
<br> </br>

- Restart nginx : `sudo systemctl restart nginx` (loads new config in default)
- Good practice to check status with `sudo systemctl status nginx`
<br> </br>
- To launch app open sync_folder/app
- Run `npm start`
- Now you should be able to open Sparta Global welcome page app while only using the ip ( no port required) : http://192.168.10.100/


- -----------------------------------
## Thursday 15. Multi Machines
- (We have to create a db VM called db and install mongodb in that. Once that's done we need to connect the app to the db to go to the d, raed the information, bring it back and display it in our browser)

- Change Vagrantfile to:
- This creates a multi machine in one vagrantfile. The main one is app and the new one is db
```
Vagrant.configure("2") do |config|
  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/xenial64"
    app.vm.network "private_network", ip:"192.168.10.100" 
    app.hostsupdater.aliases = ["development.local"]
    app.vm.synced_folder ".", "/home/vagrant/sync_folder"
    app.vm.provision "shell", path: "./environment/provision.sh"
  end 

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"  
    db.vm.network "private_network", ip: "192.168.10.150"
    db.vm.provision "shell", path: "./environment/db/provision.sh", env: {'DB_HOST' => 'mongodb://192.168.10.150:27017/posts'}
      
  end
end
```
- -----------------------------------------------------------------------------
- **Open db VM (vagrant ssh db)**
- From home location go to `cd /etc` and run `cat mongod.conf`
- Scroll down to:`# network interfaces` and change bindIP to ` bindIp: 0.0.0.0`
- To change bindIP manually, type `sudo nano mongod.conf`


- **Open APP VM (vagrant ssh app)**

- Need to create an persistant environment variable DB_HOST:
- This connects to mongodb with given ip that connects to the post. 

`sudo echo export DB_HOST="mongodb://192.168.10.150:27017/posts" >> ~/.bashrc `

- Need to run the source file to reload the information
`source ~/.bashrc`

- To check if varaible exists, run `env` or `printenv DB_HOST`

- Go to app folder: sync_folder/app
- Start app with `npm start`
- If all goes well, Check web http://192.168.10.100:3000/posts
- You should see the 'Recent Posts' and additional information, if not follow next steps:
- In `app` directory open `seeds` and run `node seed.js`
- Go back to `app` directory, run `npm start` and all should work


**Provision file**
- Create new db folder on OS: environment -> db
- Create `provision.sh` file on OS in db folder and add this:

```
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

```

