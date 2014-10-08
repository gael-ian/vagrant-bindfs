# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"

  config.vm.define "bindfstest" do |machine|
    machine.bindfs.bind_folder "/etc3", "/etc-nonexist"

    machine.bindfs.bind_folder "/etc", "/etc-binded-symbol", :chown_ignore => true
    machine.bindfs.bind_folder "/etc", "/etc-binded-string", "chown-ignore" => true
  end

  config.vm.provider :virtualbox do |provider, override|
    provider.memory = 512
    provider.cpus = 2

    #override.vm.box = ""
  end

  config.vm.provider :libvirt do |provider, override|
    provider.memory = 512
    provider.cpus = 2

    #override.vm.box = ""
  end
end
