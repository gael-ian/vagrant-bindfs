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

      guest_capability("debian", "bindfs_install") do
        require "vagrant-bindfs/cap/debian/bindfs_install"
        Cap::Debian::BindfsInstall
      end

      guest_capability("suse", "bindfs_install") do
        require "vagrant-bindfs/cap/suse/bindfs_install"
        Cap::SUSE::BindfsInstall
      end

      guest_capability("linux", "bindfs_installed") do
        require "vagrant-bindfs/cap/linux/bindfs_installed"
        Cap::Linux::BindfsInstalled
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
