# -*- mode: ruby -*-
# vi: set ft=ruby :
# please run:
# vagrant plugin install vagrant-hostmanager vagrant-cachier vagrant-vbguest vagrant-bindfs vagrant-env

# IP = "10.2.2.#{rand(02..254)}"
Vagrant.configure(2) do |config|
  config.env.enable
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define ENV['HOSTNAME'] do |node|
    node.vm.box      = 'ubuntu/xenial64'
    node.vm.hostname = ENV['HOSTNAME']
    node.vm.host_name = ENV['HOSTNAME']
    node.vm.synced_folder ".", "/vagrant", type: :nfs
    node.vm.network "private_network", ip: "10.2.2.87"
    node.vm.provision :shell, :inline => "echo \"Etc/UTC\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
  end

  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.name = ENV['HOSTNAME']
    v.memory = 2048
    v.cpus = 2
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      # owner: "_apt",
      # group: "_apt"
      type: :nfs,
      mount_options: [
        'rw',
        'vers=3',
        'tcp',
        'nolock'
      ]
    }
  end

  config.vm.provision "shell", path: "provision/ofbiz.sh",   privileged: false
  config.vm.provision "shell", inline: "cd apache-ofbiz-16.11.04 && ./gradlew 'ofbizBackground --start', run: "always"

end
