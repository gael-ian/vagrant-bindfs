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
          @app  = app
          @env  = env
          @hook = hook
        end

        def call(env)
          app.call(env)
          return if binded_folders(hook).empty?
          bind_folders!
        end

        protected

        def bind_folders!
          info I18n.t('vagrant-bindfs.actions.mounter.start', hook: hook)

          bindfs_version    = guest.capability(:bindfs_bindfs_version)
          bindfs_full_path  = guest.capability(:bindfs_bindfs_full_path)

          binded_folders(hook).each_value do |folder|
            folder.reverse_merge!(config.default_options)
            folder.to_version!(bindfs_version)

            validator = VagrantBindfs::Bindfs::Validators::Runtime.new(folder, machine)

            unless validator.valid?
              error I18n.t(
                'vagrant-bindfs.validations.errors_found',
                dest:   folder.destination,
                source: folder.source,
                errors: validator.errors.join(' ')
              )
              next
            end

            command = VagrantBindfs::Bindfs::Command.new(folder)

            detail I18n.t(
              'vagrant-bindfs.actions.mounter.entry',
              dest: folder.destination,
              source: folder.source
            )

            machine.communicate.tap do |comm|
              comm.sudo("mkdir -p #{folder.destination}")
              comm.sudo(command.to_s(bindfs_full_path), error_class: VagrantBindfs::Vagrant::Error, error_key: 'bindfs.mount_failed')
              debug(command.to_s(bindfs_full_path))
            end
          end
        end
      end
    end
  end
end
