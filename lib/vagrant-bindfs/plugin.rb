module VagrantBindfs
  class Plugin < Vagrant.plugin("2")

    name "Bindfs"
    description <<-DESC
    This plugin allows you to mount -o bind filesystems inside the guest. This is
    useful to change their ownership and permissions.
    DESC


    config(:bindfs) do
      Config
    end

    include Capabilities


    %w{up reload}.each do |action|
      action_hook(:bindfs, "machine_action_#{action}".to_sym) do |hook|
        hooks.each do |(name, action)|
          hook.before(action, Action, name)
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
