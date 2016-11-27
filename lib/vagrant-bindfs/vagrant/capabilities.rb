module VagrantBindfs
  module Vagrant
    module Capabilities
  
      def self.included(base)
  
        base.guest_capability("linux", "bindfs_check_user") do
          require "vagrant-bindfs/vagrant/capabilities/linux/checks"
          Capabilities::Linux::Checks
        end
  
        base.guest_capability("darwin", "bindfs_check_user") do
          require "vagrant-bindfs/vagrant/capabilities/darwin/checks"
          Capabilities::Darwin::Checks
        end
  
  
        base.guest_capability("linux", "bindfs_check_group") do
          require "vagrant-bindfs/vagrant/capabilities/linux/checks"
          Capabilities::Linux::Checks
        end
  
        base.guest_capability("darwin", "bindfs_check_group") do
          require "vagrant-bindfs/vagrant/capabilities/darwin/checks"
          Capabilities::Darwin::Checks
        end
  
  
        base.guest_capability("linux", "bindfs_check_mount") do
          require "vagrant-bindfs/vagrant/capabilities/all/checks"
          Capabilities::All::Checks
        end
  
        base.guest_capability("darwin", "bindfs_check_mount") do
          require "vagrant-bindfs/vagrant/capabilities/all/checks"
          Capabilities::All::Checks
        end
  
  
        base.guest_capability("linux", "bindfs_installed") do
          require "vagrant-bindfs/vagrant/capabilities/all/bindfs_installed"
          Capabilities::All::BindfsInstalled
        end
  
        base.guest_capability("darwin", "bindfs_installed") do
          require "vagrant-bindfs/vagrant/capabilities/all/bindfs_installed"
          Capabilities::All::BindfsInstalled
        end
  
  
        base.guest_capability("linux", "fuse_loaded") do
          require "vagrant-bindfs/vagrant/capabilities/linux/fuse_loaded"
          Capabilities::Linux::FuseLoaded
        end
  
        base.guest_capability("ubuntu", "fuse_loaded") do
          require "vagrant-bindfs/vagrant/capabilities/ubuntu/fuse_loaded"
          Capabilities::Ubuntu::FuseLoaded
        end
  
        base.guest_capability("darwin", "fuse_loaded") do
          require "vagrant-bindfs/vagrant/capabilities/darwin/fuse_loaded"
          Capabilities::Darwin::FuseLoaded
        end
  
  
        base.guest_capability("linux", "enable_fuse") do
          require "vagrant-bindfs/vagrant/capabilities/linux/enable_fuse"
          Capabilities::Linux::EnableFuse
        end
  
  
        base.guest_capability("debian", "install_bindfs") do
          require "vagrant-bindfs/vagrant/capabilities/debian/install_bindfs"
          Capabilities::Debian::InstallBindfs
        end
  
        base.guest_capability("redhat", "install_bindfs") do
          require 'vagrant-bindfs/vagrant/capabilities/redhat/install_bindfs'
          Capabilities::RedHat::InstallBindfs
        end
  
        base.guest_capability("fedora", "install_bindfs") do
          require 'vagrant-bindfs/vagrant/capabilities/fedora/install_bindfs'
          Capabilities::Fedora::InstallBindfs
        end
  
        base.guest_capability("suse", "install_bindfs") do
          require "vagrant-bindfs/vagrant/capabilities/suse/install_bindfs"
          Capabilities::Suse::InstallBindfs
        end
  
        base.guest_capability("darwin", "install_bindfs") do
          require "vagrant-bindfs/vagrant/capabilities/darwin/install_bindfs"
          Capabilities::Darwin::InstallBindfs
        end
      end
      
    end
  end
end
