# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Uncomment machines you want to test
test_machines = {
  # debian: { box: "bento/debian-9"     },
  # ubuntu: { box: "bento/ubuntu-17.10" },
  # fedora: { box: "bento/fedora-26"    },
  # redhat: { box: "bento/centos-7"     },

  # The `vagrant` user group does not exist in this box.
  # suse:   { box: "bento/opensuse-leap-42",      args: { group: 'users' } },

  # **This box require the Oracle VM VirtualBox Extension Pack for Virtualbox.**
  # The `vagrant` user group does not exist in this box.
  # osx:    { box: "jhcook/osx-elcapitan-10.11",  args: { group: 'staff' } },

  # When you add a new test machine, please ensure that it will stay
  # available and regularly updated for future tests. We recommend to
  # use officialy supported boxes, as stated in the Vagrant
  # documentation. See https://goo.gl/LbkPVF
}

require File.expand_path('../spec/vagrantfile_helper', __FILE__)

Vagrant.configure('2') do |config|
  # Common configuration
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  # For a more detailled output when you test, set this to true.
  config.bindfs.debug = false

  test_machines.each do |distro, options|
    config.vm.define "vagrant-bindfs-test-#{distro}" do |machine|
      machine.vm.box = options[:box]
      tests_setup(machine, (options[:args] || {}))
    end
  end
end
