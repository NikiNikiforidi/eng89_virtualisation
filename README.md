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

## Introduction to provision

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
## Tuesday  13, syncing folders

**Added app and environment folder to our directory**
<br>
  

  
</br>
- step2. Create provision.sh folder and add below code:
- (make sure top 3 line has -y otherwise it wil geet stuck)
```
!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo systemctl status nginx
```
- To sync local host file (provision.sh) to VM, add below code in vagrantfile :

```
config.vm.synced_folder " (1) ", "(2) "

# (1) The first parameter is a path to a directory on the host machine.
# (2) The second parameter must be an absolute path of where to share the folder within the guest machine.
# You can check this path by typying in `pwd` in your VM
```

- If you want to sync everything froom current location of vagrantfile, replace the whole path with a dot .
```
- config.vm.synced_folder '.', '/home/vagrant/NEW_FILE_NAME'
```

- To run provision file once sinc is happening (in vagrantfile):
```
config.vm.provision "shell", path:"./PATH/provision.sh"

```
- ------------------------------------------------
**Persistant variable**

- To create a varaible:
```
env name=Niki
```
To make the variable persistent:
```
export name=Niki

```

- To check all variables:
```
env
```
- To check for specific variable:
```
printenv name
```
- -----------------------------------------------

### Spec Test

- go to environment -> spec-test file and enter:
```
gem install bundler

```
- to run test, must be in the spec test folder:
```

rake spec
```
- 3 tests fail. nodejs, nodejs --version and pm2
- to install nodejs (done in VM)

```
sudo apt-get install nodejs -y
```
- to stall nodejs --version (in VM)(run each line seperatly) 

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
- Finally, to install pm2 (in vm)
```
sudo npm install pm2 -g
```
- ------------------------------------------------------------------
**Run Sparta Global app**
- if everything has installed correctly, you should add (in the VM -> APP folder):
```
node app.js

```
- You should get a message that says: Your app is ready and listening on port 3000
- If ouopen your browser and type the ip and post number (http://192.168.10.100:3000/) and should get a Sparta Global welcom page.
- Additionally, if you type this (http://192.168.10.100:3000/fibonacci/6) in the browser ypu should get another page that returns the fibonacci number of 6. Note: it doesn't have to be the number 6, can be anythingls


- -----------------------------------------------
### Vagrantfile looks like:

```

Vagrant.configure("2") do |config|
  

  config.vm.box = "ubuntu/xenial64"
  # using ubuntu 16.04 LTS box
  
  # let's connect to nginx using private ip
    config.vm.network "private_network", ip: "192.168.10.100"
  # we would like to load this ip using our host machine's browser
  # to view default nginx page
   
    config.hostsupdater.aliases = ["development.local"]
    # if the plugin is installed correctly and file is update with vagrant destroy then vagrant up
    # we should be able to see nginx page in the browser with http://development.local 



    config.vm.synced_folder ".", "/home/vagrant/sync_folder"
    # If you want to sync everything froom current location of vagrant file, replace the whole path with a dot .
    # config.vm.synced_folder '.', "/home/vagrant/environment"
    

    config.vm.provision "shell", path:"./environment/provision.sh"
end
```
- ----------------------------------------------------------------
**Put everything in the provision.sh file:**

```
!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo systemctl status nginx

# Install to pass test
sudo apt-get install nodejs -y
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2 -g -y

systemctl status nginx
npm install -y
npm start


```
- --------------------------
**Wednesday 14th**

- To write something and save it to a file that doesn't exist 
```
sudo "ADD_TEXT" >> test.text

```
- --------------------------------------
### Reverse Proxi

- In VM, open /etc -> nginx -> sites_available (defualt file available)
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
- Restart nginx : `sudo systemctl restart nginx` (loads new config in default)
- Good practice to check status with `sudo systemctl status nginx`

- To launch app open env -> app
- Run `npm` start
 - -----------------------------------
 ### Launch app

 - Step 1: Open VM and open `/ect`
 - Step 2: open `nginx/`
 - Step 3: open `sites-available`
 - Step 4: Go back to `/home/vagrant` directory
 - step 5: Open `sync_folder` -> `app`
 - Step 6: run: `npm start`
 - Should get a reply that says:Your app is ready and listening on port 3000
- Now you should be able to open Sparta Global welcome page app while only using the ip ( no port required) : http://192.168.10.100/


- -----------------------------------
**Thursday 15**
### Multi Machines
- This multimachine was created in the same foldes as above.
- Mauall

- Change Vagrantfile to:
- This creates a multi machine in one vagrantfile. The main one is app and the new one is db

```

Vagrant.configure("2") do |config|

 config.vm.define "app" do |app|
   app.vm.box = "ubuntu/xenial64"
   app.vm.network "private_network", ip:"192.168.10.100"
   app.hostsupdater.aliases = ["development.local"]
   app.vm.synced_folder ".", "/home/vagrant/sync_folder"
   app.vm.provision "shell", path:"./environment/provision.sh"
  
 end

# Configuring a new machine and configuring it and giving it a private ip
 config.vm.define "db" do |db|
   db.vm.box = "ubuntu/xenial64"
   db.vm.network "private_network", ip:"192.168.10.150"
   db.vm.provision "shell", path:"./environment/db/provision.sh"
   db.hostsupdater.aliases = ["database.local"]
 end

end


```

- **Install mongodb**
- Create new db folder on OS: environment -> db
- Create `provision.sh` file on OS in db folder and add this:

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20

sudo rm /etc/mongod.conf
sudo ln -s /home/vagrant/environment/mongod.conf /etc/mongod.conf

sudo systemctl restart mongodb
sudo systemctl enable mongod
```

- **Open db VM (vagrant ssh db)**
- From home location go to `cd /etc` -> `cat mongod.conf`
- Scroll down to:`# network interfaces` and change bindIP to ` bindIp: 0.0.0.0`
- To change bindIP type `sudo nano mongod.conf`

- **Open APP VM (vagrant ssh app)**

- Need to create an persistant environment variable DB_HOST:
- This connects to mongodb with given ip that connects to the post. 

`sudo echo export DB_HOST="mongodb://192.168.10.150:27017/posts" >> ~/.bashrc `

- Need to run the source file to reload the information
`source ~/.bashrc`

- To check if varaible exists, run `env` or `printenv DB_HOST`

- Go to app folder: `sync_folder` -> `app`
- Start app with `npm start`
- If all goes well, Check web http://192.168.10.100:3000/posts
- You should see the 'Recent Posts' and additional information, if not follow next steps:
- In `app` directory open `seeds` and run `node seed.js`
- Go back to `app` directory, run `npm start` and all should work
