# Setting up Development Env
## Installation of Vagrant, virtual box and Ruby
### Vagrant Commands
-  `vagrant up` to launch the vm
- `vagrant destroy` to delete everything
- `vagrant reload` to reload any new instructions in our `Vagrantfile`
- `vagrant halt` it poses the
 -`vagrant status` 
#### `vagrant` shows a lost of commands:

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




- Let's `ssh` into our vm an dlaunch nginx web-server
- use `apt-get` package manager in Linux. It's used to install/uninstall any packages 
- To use the command in `admin` mode we use `sude` before the command
- `sudo apt-get upgrade -y` 
- `sudo apt-get update -y`
- `ping www.bbc.co.uk`
- `sudo apt-get install name_of_package`
- To work in `admin mode` at all times (not recommended) `sudo -su` and you'll land in admin mode
- We will install nginx in our guest machine/VM/ubuntu 16.04
- launch the defult nginx page in host machine's browser
- To come out of your VM `exit`
- install nginx `sudo apt-get install nginx -y`
- checking status of nginx `systemctl status nginx`
- restart `systemctl restart nginx`
- just to start `systemctl start nginx`

- ----------------------------------------------
**Installing plugin**

- step 1: Install the plugin: vagrant plugin install vagrant-hostsupdater

- step 2: vagrant destroy

- step 3: add this line of code into Vagrantfile config.hostsupdater.aliases = ["development.local"]

    - To check status `vagrant status`, nothing should be running

- step 4: vagrant up

- step 5: vagrant ssh

- step 6: repeat all the update and upgrade commands followed by installing nginx and checking of nginx
  -`sudo apt-get update -y`
  - `sudo apt-get upgrade -y `
  - `sudo apt-get install nginx`
  - `sudo systemctl status nginx`


- ningx status active should load nginx in the browswer with 192.168.10.100 as well as http://development.local/

-`vagrant halt`

- ----------------------------------------------------

**Reload/Destroy vagrant**
- 1) `vagrant reload` (if this does not work, you will have to `vagrant destroy` and then do `vagrant up` again)
- 2) `vagrant ssh` Opens VM
- 3) `systemctl status nginx` 
- 4) Go to browser and write: http://development.local
- exit) control + c to exit
- ---------------------------------------------------- 
- Lets automate the tast that we did manually earlier today
- Create a file called `provision.sh`. Add below code to new file: 

- make sure to add `#!/bin/bash`
- `sudo apt-get update -y`
- `sude apt-get upgrade -y`
- `sudo apt-get install nginx` (if making an automated file, make sure you write `-y` at the end of this line)
- `sudo systemctl status nginx `

- To run provision.sh we need to give file permission and make this file exceutable
- To change permission we use `chmod` with required permission then file name
- `chmod +x provision.sh`


- `sudo chmod +x provision.sh` Change permission as admin . It turns green when completed
-To run `sudo ./provision.sh`



- --------------------------------------------

**Tuesday  13, syncing folders**

- Step1, vagrent destroy
- step2. Create provision.sh folder and add below code:
- (make sure top 3 line has -y otherwise it wil geet stuck)
```
!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo systemctl status nginx
```
- To sync add below code in vagrantfile :

```
config.vm.synced_folder " (1) ", "(2) "

# (1) The first parameter is a path to a directory on the host machine.
#(2) The second parameter must be an absolute path of where to share the folder within the guest machine.
# You can check this path by typying in `pwd` in your VM
```





