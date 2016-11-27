# -*- mode: ruby -*-
# vi: set ft=ruby :

# Uncomment machines you want to test
test_machines = {
  # debian: { box: "bento/debian-8.5"   },
  # ubuntu: { box: "bento/ubuntu-16.04" },
  # fedora: { box: "bento/fedora-24"    },
  # redhat: { box: "bento/centos-7.2"   },
  
  # The `vagrant` user group does not exist in this box.
  # suse:   { box: "bento/opensuse-leap-42.1",    args: { group: 'users' } },
  
  # **This box require the Oracle VM VirtualBox Extension Pack for Virtualbox.**
  # The `vagrant` user group does not exist in this box.
  # osx:    { box: "jhcook/osx-elcapitan-10.11",  args: { group: 'staff' } },

  # When you add a new test machine, please ensure that it will stay
  # available and regularly updated for future tests. We recommend to
  # use officialy supported boxes, as stated in the Vagrant
  # documentation. See https://goo.gl/LbkPVF
}

require File.expand_path("../spec/vagrantfile_helper", __FILE__)

Vagrant.configure("2") do |config|

  # Common configuration
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 2
  end

  test_machines.each do |distro, options|
    config.vm.define "vagrant-bindfs-test-#{distro}" do |machine|
      machine.vm.box = options[:box]
      tests_setup(machine, (options[:args] || {}))
    end
  end
end

