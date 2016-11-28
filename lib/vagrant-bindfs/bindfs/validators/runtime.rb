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

          unless machine.guest.capability(:bindfs_exists_directory, source)
            @errors << I18n.t("vagrant-bindfs.validations.source_path_does_not_exist", path: source)
          end
        end

        def validate_destination!
          super

          if machine.guest.capability(:bindfs_exists_mount, destination)
            @errors << I18n.t("vagrant-bindfs.validations.destination_already_mounted", dest: destination)
          end
        end

        def validate_options!
          super

          unless machine.config.bindfs.skip_validations.include?(:user)
            unless machine.guest.capability(:bindfs_exists_user, options['force-user'])
              @errors << I18n.t("vagrant-bindfs.validations.user_does_not_exist", user: options['force-user'])
            end
          end

          unless machine.config.bindfs.skip_validations.include?(:group)
            unless machine.guest.capability(:bindfs_exists_group, options['force-group'])
              @errors << I18n.t("vagrant-bindfs.validations.group_does_not_exist", group: options['force-group'])
            end
          end
        end

      end
    end
  end
end
