

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
