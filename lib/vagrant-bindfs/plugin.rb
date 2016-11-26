module VagrantBindfs
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


    guest_capability("linux", "bindfs_check_user") do
      require "vagrant-bindfs/cap/linux/checks"
      Cap::Linux::Checks
    end

    guest_capability("darwin", "bindfs_check_user") do
      require "vagrant-bindfs/cap/darwin/checks"
      Cap::Darwin::Checks
    end


    guest_capability("linux", "bindfs_check_group") do
      require "vagrant-bindfs/cap/linux/checks"
      Cap::Linux::Checks
    end

    guest_capability("darwin", "bindfs_check_group") do
      require "vagrant-bindfs/cap/darwin/checks"
      Cap::Darwin::Checks
    end


    guest_capability("linux", "bindfs_check_mount") do
      require "vagrant-bindfs/cap/all/checks"
      Cap::All::Checks
    end

    guest_capability("darwin", "bindfs_check_mount") do
      require "vagrant-bindfs/cap/all/checks"
      Cap::All::Checks
    end


    guest_capability("linux", "bindfs_installed") do
      require "vagrant-bindfs/cap/all/bindfs_installed"
      Cap::All::BindfsInstalled
    end

    guest_capability("darwin", "bindfs_installed") do
      require "vagrant-bindfs/cap/all/bindfs_installed"
      Cap::All::BindfsInstalled
    end


    guest_capability("linux", "fuse_loaded") do
      require "vagrant-bindfs/cap/linux/fuse_loaded"
      Cap::Linux::FuseLoaded
    end

    guest_capability("ubuntu", "fuse_loaded") do
      require "vagrant-bindfs/cap/ubuntu/fuse_loaded"
      Cap::Ubuntu::FuseLoaded
    end

    guest_capability("darwin", "fuse_loaded") do
      require "vagrant-bindfs/cap/darwin/fuse_loaded"
      Cap::Darwin::FuseLoaded
    end


    guest_capability("linux", "enable_fuse") do
      require "vagrant-bindfs/cap/linux/enable_fuse"
      Cap::Linux::EnableFuse
    end


    guest_capability("debian", "install_bindfs") do
      require "vagrant-bindfs/cap/debian/install_bindfs"
      Cap::Debian::InstallBindfs
    end

    guest_capability("redhat", "install_bindfs") do
      require 'vagrant-bindfs/cap/redhat/install_bindfs'
      Cap::RedHat::InstallBindfs
    end

    guest_capability("fedora", "install_bindfs") do
      require 'vagrant-bindfs/cap/fedora/install_bindfs'
      Cap::Fedora::InstallBindfs
    end

    guest_capability("suse", "install_bindfs") do
      require "vagrant-bindfs/cap/suse/install_bindfs"
      Cap::Suse::InstallBindfs
    end

    guest_capability("darwin", "install_bindfs") do
      require "vagrant-bindfs/cap/darwin/install_bindfs"
      Cap::Darwin::InstallBindfs
    end


    require "vagrant-bindfs/bind"

    %w{up reload}.each do |action|
      action_hook(:bindfs, "machine_action_#{action}".to_sym) do |hook|
        hooks.each do |(name, action)|
          hook.before(action, Action::Bind, name)
        end
      end
    end

    class << self

      def hooks
        @hooks ||= begin
          synced_folders = if Vagrant::Action::Builtin.const_defined? :NFS
            Vagrant::Action::Builtin::NFS
          else
            Vagrant::Action::Builtin::SyncedFolders
          end

          {
            :synced_folders => synced_folders,
            :provision      => Vagrant::Action::Builtin::Provision
          }
        end
      end

      def hook_names
        hooks.keys
      end

    end

  end
end
