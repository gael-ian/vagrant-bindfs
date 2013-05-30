module VagrantPlugins
  module Bindfs
    class Plugin < Vagrant.plugin("2")
      name "Bindfs"
      description <<-DESC
      This plugin allows you to mount -o bind filesystems inside the guest. This is 
      useful to change their ownership and permissions.
      DESC

      config(:bindfs) do
        require 'vagrant-bindfs/config'
        Config
      end

      action_hook(:bindfs, :machine_action_up) do |hook|
        require 'vagrant-bindfs/bind'
        hook.prepend(Action::Bind)
      end
    end
  end
end
