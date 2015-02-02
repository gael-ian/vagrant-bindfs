module VagrantPlugins
  module Bindfs
    class Plugin < Vagrant.plugin("2")
      
      name "Bindfs"
      description <<-DESC
      This plugin allows you to mount -o bind filesystems inside the guest. This is
      useful to change their ownership and permissions.
      DESC

      
      config(:bindfs) do
        require "vagrant-bindfs/config"
        Config
      end
      

      guest_capability("linux", "bindfs_installed") do
        require "vagrant-bindfs/cap/linux/bindfs_installed"
        Cap::Linux::BindfsInstalled
      end

      
      guest_capability("linux", "fuse_loaded") do
        require "vagrant-bindfs/cap/linux/fuse_loaded"
        Cap::Linux::FuseLoaded
      end
      
      guest_capability("ubuntu", "fuse_loaded") do
        require "vagrant-bindfs/cap/ubuntu/fuse_loaded"
        Cap::Ubuntu::FuseLoaded
      end

      
      guest_capability("linux", "enable_fuse") do
        require "vagrant-bindfs/cap/linux/enable_fuse"
        Cap::Linux::EnableFuse
      end
      

      guest_capability("debian", "install_bindfs") do
        require "vagrant-bindfs/cap/debian/install_bindfs"
        Cap::Debian::InstallBindfs
      end

      guest_capability("suse", "install_bindfs") do
        require "vagrant-bindfs/cap/suse/install_bindfs"
        Cap::Suse::InstallBindfs
      end

      guest_capability("fedora", "install_bindfs") do
        require 'vagrant-bindfs/cap/fedora/install_bindfs'
        Cap::Fedora::InstallBindfs
      end

      guest_capability("redhat", "install_bindfs") do
        require 'vagrant-bindfs/cap/redhat/install_bindfs'
        Cap::RedHat::InstallBindfs
      end
      

      require "vagrant-bindfs/bind"

      %w{up reload}.each do |action|
        action_hook(:bindfs, "machine_action_#{action}".to_sym) do |hook|
          target = if Vagrant::Action::Builtin.const_defined? :NFS
            Vagrant::Action::Builtin::NFS
          else
            Vagrant::Action::Builtin::SyncedFolders
          end

          hook.before(target, Action::Bind)
        end
      end
      
    end
  end
end
