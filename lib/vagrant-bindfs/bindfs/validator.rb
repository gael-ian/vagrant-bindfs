module VagrantBindfs
  module Bindfs
    class Validator

      attr_reader :folder
      attr_reader :errors

      extend Forwardable
      def_delegator :@folder, :source
      def_delegator :@folder, :destination
      def_delegator :@folder, :options

      def initialize(folder, machine = nil)
        @folder   = folder
        @machine  = machine
        @errors   = []
      end

      def valid?
        @errors = []
        validate_source!
        validate_destination!
        validate_options!
        @errors.empty?
      end

      protected

      def validate_source!
        if source.empty?
          @errors << I18n.t("vagrant-bindfs.validations.source_path_required")
        end

        if Pathname.new(source).relative?
          @errors << I18n.t("vagrant-bindfs.validations.path_must_be_absolute", path: source)
        end

        return unless machine_ready?

        unless @machine.guest.capability(:bindfs_exists_directory, source)
          @errors << I18n.t("vagrant-bindfs.validations.source_path_does_not_exist", path: source)
        end
      end

      def validate_destination!
        if destination.empty?
          @errors << I18n.t("vagrant-bindfs.validations.destination_path_required")
        end

        if Pathname.new(destination).relative?
          @errors << I18n.t("vagrant-bindfs.validations.path_must_be_absolute", path: destination)
        end

        if !(Pathname.new(destination).to_path.match(/^\/vagrant/).nil?)
          @errors << I18n.t("vagrant-bindfs.validations.destination_path_reserved", path: destination)
        end

        return unless machine_ready?

        if @machine.guest.capability(:bindfs_exists_mount, destination)
          @errors << I18n.t("vagrant-bindfs.validations.destination_already_mounted", dest: destination)
        end
      end

      def validate_options!

        # TODO: Deprecation for
        # :skip_verify_user
        # :skip_verify_group
        # :disabled
        # :hook

        return unless machine_ready?

        unless @machine.guest.capability(:bindfs_exists_user, options['force-user'])
          @errors << I18n.t("vagrant-bindfs.validations.user_does_not_exist", user: options['force-user'])
        end

        unless @machine.guest.capability(:bindfs_exists_group, options['force-group'])
          @errors << I18n.t("vagrant-bindfs.validations.group_does_not_exist", group: options['force-group'])
        end
      end

      def machine_ready?
        (@machine && @machine.communicate.ready?)
      end

    end
  end
end
