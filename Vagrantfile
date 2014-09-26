# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_plugin "vagrant-bindfs"

Vagrant.configure("2") do |master_config|
  master_config.vm.define "bindfstest" do |config|
    config.vm.box = "airbase"
    config.vm.box_url = "https://s3.amazonaws.com/gsc-vagrant-boxes/ubuntu-12.04-omnibus-chef.box"

    config.bindfs.bind_folder "/etc3", "/etc-nonexit"
    config.bindfs.bind_folder "/etc", "/etc-binded", :"chown-ignore" => true

    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id,
        "--memory", "512",
        "--cpus",   "2",
      ]
    end

  end
end
