# -*- mode: ruby -*-
# vi: set ft=ruby :

def setup(machine)

  machine.bindfs.debug = true
  
  machine.vm.provider :virtualbox do |provider, _|
    provider.memory = 512
    provider.cpus = 2
  end

  machine.bindfs.bind_folder "/etc",  "/etc-binded-symbol", chown_ignore: true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-string", "chown-ignore" => true

  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-option", owner: "root"
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-flag", "create-as-user" => true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-short-option", r: true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-without-explicit-owner", owner: nil

  # This should fail
  machine.bindfs.bind_folder "/etc3", "/etc-nonexit"

  # These should also fail
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-nonexistent-user", user: "nonuser", after: :provision
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-nonexistent-group", group: "nongroup", after: :provision  

end


Vagrant.configure("2") do |config|

  # Debian machine
  # config.vm.define "bindfs-test-debian" do |machine|
  #   machine.vm.box = "debian/jessie64"
  #   setup machine
  # end

  # Fedora machine
  # config.vm.define "bindfs-test-fedora" do |machine|
  #   machine.vm.box = "fedora/23-cloud-base"
  #   setup machine 
  # end

  # RedHat machine (CentOS 7)
  # config.vm.define "bindfs-test-centos-7" do |machine|
  #   machine.vm.box = "centos/7"
  #   setup machine
  # end

  # Suse machine
  # config.vm.define "bindfs-test-suse" do |machine|
  #   machine.vm.box = ?
  #   setup machine 
  # end

  # Ubuntu 14.04 with bindfs 1.12.3
  # config.vm.define "bindfs-test-ubuntu-14.04" do |machine|
  #   machine.vm.box = "ubuntu/trusty64"
  #   setup machine
  # end

end

