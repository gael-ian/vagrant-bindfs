module VagrantBindfs
  module Capabilities

    def self.included(base)

      base.guest_capability("linux", "bindfs_check_user") do
        require "vagrant-bindfs/capabilities/linux/checks"
        Capabilities::Linux::Checks
      end

      base.guest_capability("darwin", "bindfs_check_user") do
        require "vagrant-bindfs/capabilities/darwin/checks"
        Capabilities::Darwin::Checks
      end


      base.guest_capability("linux", "bindfs_check_group") do
        require "vagrant-bindfs/capabilities/linux/checks"
        Capabilities::Linux::Checks
      end

      base.guest_capability("darwin", "bindfs_check_group") do
        require "vagrant-bindfs/capabilities/darwin/checks"
        Capabilities::Darwin::Checks
      end


      base.guest_capability("linux", "bindfs_check_mount") do
        require "vagrant-bindfs/capabilities/all/checks"
        Capabilities::All::Checks
      end

      base.guest_capability("darwin", "bindfs_check_mount") do
        require "vagrant-bindfs/capabilities/all/checks"
        Capabilities::All::Checks
      end


      base.guest_capability("linux", "bindfs_installed") do
        require "vagrant-bindfs/capabilities/all/bindfs_installed"
        Capabilities::All::BindfsInstalled
      end

      base.guest_capability("darwin", "bindfs_installed") do
        require "vagrant-bindfs/capabilities/all/bindfs_installed"
        Capabilities::All::BindfsInstalled
      end


      base.guest_capability("linux", "fuse_loaded") do
        require "vagrant-bindfs/capabilities/linux/fuse_loaded"
        Capabilities::Linux::FuseLoaded
      end

      base.guest_capability("ubuntu", "fuse_loaded") do
        require "vagrant-bindfs/capabilities/ubuntu/fuse_loaded"
        Capabilities::Ubuntu::FuseLoaded
      end

      base.guest_capability("darwin", "fuse_loaded") do
        require "vagrant-bindfs/capabilities/darwin/fuse_loaded"
        Capabilities::Darwin::FuseLoaded
      end


      base.guest_capability("linux", "enable_fuse") do
        require "vagrant-bindfs/capabilities/linux/enable_fuse"
        Capabilities::Linux::EnableFuse
      end


      base.guest_capability("debian", "install_bindfs") do
        require "vagrant-bindfs/capabilities/debian/install_bindfs"
        Capabilities::Debian::InstallBindfs
      end

      base.guest_capability("redhat", "install_bindfs") do
        require 'vagrant-bindfs/capabilities/redhat/install_bindfs'
        Capabilities::RedHat::InstallBindfs
      end

      base.guest_capability("fedora", "install_bindfs") do
        require 'vagrant-bindfs/capabilities/fedora/install_bindfs'
        Capabilities::Fedora::InstallBindfs
      end

      base.guest_capability("suse", "install_bindfs") do
        require "vagrant-bindfs/capabilities/suse/install_bindfs"
        Capabilities::Suse::InstallBindfs
      end

      base.guest_capability("darwin", "install_bindfs") do
        require "vagrant-bindfs/capabilities/darwin/install_bindfs"
        Capabilities::Darwin::InstallBindfs
      end
    end

  end
end
