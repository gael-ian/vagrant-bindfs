# -*- mode: ruby -*-
# vi: set ft=ruby :

# Uncomment machines you want to test
test_machines = {
  # debian: "bento/debian-8.5",
  # ubuntu: "bento/ubuntu-16.04",
  # fedora: "bento/fedora-24",
  # redhat: "bento/centos-7.2",
  # suse:   "bento/opensuse-leap-42.1",
  osx:    "jhcook/osx-elcapitan-10.11",

  # When you add a new test machine, please ensure that it will stay
  # available and regularly updated for future tests. We recommend to
  # use officialy supported boxes, as stated in the Vagrant
  # documentation. See https://goo.gl/LbkPVF
}

def setup(machine)

  machine.bindfs.debug = true

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

  # Common configuration
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 2
  end

  test_machines.each do |distro, base_box|
    config.vm.define "vagrant-bindfs-test-#{distro}" do |machine|
      machine.vm.box = base_box
      setup machine
    end
  end
end

