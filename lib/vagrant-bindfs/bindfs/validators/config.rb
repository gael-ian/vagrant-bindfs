module VagrantBindfs
  module Bindfs
    module Validators
      class Config

        attr_reader :folder
        attr_reader :errors

        extend Forwardable
        def_delegator :@folder, :source
        def_delegator :@folder, :destination
        def_delegator :@folder, :options

        def initialize(folder)
          @folder   = folder
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
        end

        def validate_options!
          invalid_options = folder.options.invalid_options.keys
          @errors << I18n.t("vagrant-bindfs.deprecations.disabled")           if invalid_options.include?('disabled')
          @errors << I18n.t("vagrant-bindfs.deprecations.skip_verify_user")   if invalid_options.include?('skip-verify-user')
          @errors << I18n.t("vagrant-bindfs.deprecations.skip_verify_group")  if invalid_options.include?('skip-verify-group')
          @errors << I18n.t("vagrant-bindfs.deprecations.hook")               if invalid_options.include?('hook')
        end

      end
    end
  end
end
