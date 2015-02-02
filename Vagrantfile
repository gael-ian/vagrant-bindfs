# -*- mode: ruby -*-
# vi: set ft=ruby :

bind_folders = Proc.new do |machine|

  machine.bindfs.bind_folder "/etc",  "/etc-binded-symbol", chown_ignore: true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-string", "chown-ignore" => true

  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-option", owner: "root"
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-flag", "create-as-user" => true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-short-option", r: true

  # This should fail
  machine.bindfs.bind_folder "/etc3", "/etc-nonexit"

end

Vagrant.configure("2") do |config|

  # Ubuntu 12.04 with bindfs 1.9
  # config.vm.define "bindfs-test-airbase" do |machine|
  # 
  #   machine.vm.box      = "airbase"
  #   machine.vm.box_url  = "https://s3.amazonaws.com/gsc-vagrant-boxes/ubuntu-12.04-omnibus-chef.box"
  # 
  #   machine.vm.provider :virtualbox do |v|
  #     v.customize ["modifyvm", :id,
  #       "--memory", "512",
  #       "--cpus", "2",
  #     ]
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # Debian machine
  # config.vm.define "bindfs-test-debian" do |machine|
  #   machine.vm.box = "chef/debian-7.6"
  # 
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # Fedora machine
  # config.vm.define "bindfs-test-fedora" do |machine|
  #   machine.vm.box = "chef/fedora-20"
  # 
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # RedHat machine (CentOS 7)
  # config.vm.define "bindfs-test-centos-7" do |machine|
  #   machine.vm.box = "chef/centos-7.0"
  # 
  #   machine.bindfs.default_options perms: "u=rwX:g=rwD:o=rwD"
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # RedHat machine (CentOS 6)
  # config.vm.define "bindfs-test-centos-6" do |machine|
  #   machine.vm.box = "chef/centos-6.6"
  # 
  #   machine.bindfs.default_options perms: "u=rwX:g=rwD:o=rwD"
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # Suse machine
  # config.vm.define "bindfs-test-suse" do |machine|
  #   machine.vm.box = ?
  # 
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # Ubuntu 12.04 with bindfs 1.9
  # config.vm.define "bindfs-test-ubuntu-12.04" do |machine|
  #   machine.vm.box = "ubuntu/precise64"
  # 
  #   machine.bindfs.default_options perms: "u=rwX:g=rwD:o=rwD"
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

  # Ubuntu 14.04 with bindfs 1.12.3
  # config.vm.define "bindfs-test-ubuntu-14.04" do |machine|
  #   machine.vm.box = "ubuntu/trusty64"
  # 
  #   machine.bindfs.debug = true
  # 
  #   machine.vm.provider :virtualbox do |provider, _|
  #     provider.memory = 512
  #     provider.cpus = 2
  #   end
  # 
  #   bind_folders.call(machine)
  # end

end
