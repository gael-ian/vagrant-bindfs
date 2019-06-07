# frozen_string_literal: true

module VagrantBindfs
  module Bindfs
    module Validators
      class Runtime < Config
        attr_reader :machine

        def initialize(folder, machine)
          super(folder)
          @machine = machine
        end

        protected

        def validate_source!
          super

          @errors << I18n.t('vagrant-bindfs.validations.source_path_does_not_exist', path: source) unless directory_exists?(source)
        end

        def validate_destination!
          super

          @errors << I18n.t('vagrant-bindfs.validations.destination_already_mounted', dest: destination) if mount_exists?(destination)
        end

        def validate_options!
          super

          validate_user
          validate_group
        end

        def directory_exists?(path)
          machine.guest.capability(:bindfs_exists_directory, path)
        end

        def mount_exists?(path)
          machine.guest.capability(:bindfs_exists_mount, path)
        end

        def validate_user
          return if machine.config.bindfs.skip_validations.include?(:user)
          return if machine.guest.capability(:bindfs_exists_user, options['force-user'])

          @errors << I18n.t('vagrant-bindfs.validations.user_does_not_exist', user: options['force-user'])
        end

        def validate_group
          return if machine.config.bindfs.skip_validations.include?(:group)
          return if machine.guest.capability(:bindfs_exists_group, options['force-group'])

          @errors << I18n.t('vagrant-bindfs.validations.group_does_not_exist', group: options['force-group'])
        end
      end
    end
  end
end
