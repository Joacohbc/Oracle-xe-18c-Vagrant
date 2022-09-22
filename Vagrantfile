# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "./OracleBDv2.box"
  
  # Marco los puertos
  config.vm.network "forwarded_port", guest: 1521, host: 1521

  # Marco que no quier un Shared Folder
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Marco los puertos
  config.vm.network "forwarded_port", guest: 1521, host: 1521

  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
  end
  
end