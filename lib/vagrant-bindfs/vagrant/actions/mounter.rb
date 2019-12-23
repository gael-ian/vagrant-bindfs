# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Actions
      class Mounter
        attr_reader :app
        attr_reader :env
        attr_reader :hook

        include Concerns::Machine
        include Concerns::Log

        def initialize(app, env, hook)
          @app = app
          @env = env
          @hook = hook
        end

        def call(env)
          app.call(env)
          return if bound_folders(hook).empty?

          bind_folders!
        end

        protected

        def bind_folders!
          info I18n.t('vagrant-bindfs.actions.mounter.start', hook: hook)
          bound_folders(hook).each_value do |folder|
            bind_folder!(folder)
          end
        end

        def bind_folder!(folder)
          folder.reverse_merge!(config.default_options)
          folder.to_version!(bindfs_version)

          return unless valid_folder?(folder)

          machine.communicate.tap do |comm|
            empty_mountpoint!(comm, folder) if empty_mountpoint?(folder)
            ensure_mountpoint_exists!(comm, folder)
            execute_bind_command!(comm, folder)
          end
        end

        def valid_folder?(folder)
          validator = VagrantBindfs::Bindfs::Validators::Runtime.new(folder, machine)
          return true if validator.valid?

          error I18n.t(
            'vagrant-bindfs.validations.errors_found',
            dest: folder.destination,
            source: folder.source,
            errors: validator.errors.join(' ')
          )
          false
        end

        def empty_mountpoint?(folder)
          return false unless config.force_empty_mountpoints
          return false if folder.options.key?('o') && !folder.options['o'].match(/nonempty/).nil?

          true
        end

        def empty_mountpoint!(comm, folder)
          detail I18n.t(
            'vagrant-bindfs.actions.mounter.force_empty_mountpoints',
            dest: folder.destination
          )

          comm.sudo("rm -rf #{folder.destination}")
        end

        def ensure_mountpoint_exists!(comm, folder)
          comm.sudo("mkdir -p #{folder.destination}")
        end

        def execute_bind_command!(comm, folder)
          detail I18n.t(
            'vagrant-bindfs.actions.mounter.entry',
            dest: folder.destination,
            source: folder.source
          )

          command = VagrantBindfs::Bindfs::Command.new(folder)
          comm.sudo(command.to_s(bindfs_full_path), error_class: VagrantBindfs::Vagrant::Error, error_key: 'bindfs.mount_failed')
          debug(command.to_s(bindfs_full_path))
        end

        def bindfs_version
          @bindfs_version ||= guest.capability(:bindfs_bindfs_version)
        end

        def bindfs_full_path
          @bindfs_full_path ||= guest.capability(:bindfs_bindfs_full_path)
        end
      end
    end
  end
end
