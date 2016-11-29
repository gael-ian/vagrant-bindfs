# frozen_string_literal: true
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
          @errors << I18n.t('vagrant-bindfs.validations.source_path_required')                if source.empty?
          @errors << I18n.t('vagrant-bindfs.validations.path_must_be_absolute', path: source) if relative_path?(source)
        end

        def validate_destination!
          @errors << I18n.t('vagrant-bindfs.validations.destination_path_required')                     if destination.empty?
          @errors << I18n.t('vagrant-bindfs.validations.path_must_be_absolute', path: destination)      if relative_path?(destination)
          @errors << I18n.t('vagrant-bindfs.validations.destination_path_reserved', path: destination)  if reserved_path?(destination)
        end

        def validate_options!
          invalid_options = folder.options.invalid_options.keys
          @errors << I18n.t('vagrant-bindfs.deprecations.disabled')           if invalid_options.include?('disabled')
          @errors << I18n.t('vagrant-bindfs.deprecations.skip_verify_user')   if invalid_options.include?('skip-verify-user')
          @errors << I18n.t('vagrant-bindfs.deprecations.skip_verify_group')  if invalid_options.include?('skip-verify-group')
          @errors << I18n.t('vagrant-bindfs.deprecations.hook')               if invalid_options.include?('hook')
        end

        def relative_path?(path)
          Pathname.new(path).relative?
        end

        def reserved_path?(path)
          !Pathname.new(path).to_path.match(%r{^\/vagrant\/}).nil?
        end
      end
    end
  end
end
