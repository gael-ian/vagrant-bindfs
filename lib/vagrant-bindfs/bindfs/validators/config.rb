# frozen_string_literal: true

require 'forwardable'

module VagrantBindfs
  module Bindfs
    module Validators
      class Config
        attr_reader :folder
        attr_reader :errors

        extend ::Forwardable
        def_delegators :@folder, :source, :destination, :options

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
        end

        def validate_options!
          folder.options.invalid_options.keys.each do |option_name|
            @errors << I18n.t(option_name.tr('-', '_'), scope: 'vagrant-bindfs.deprecations')
          end
        end

        def relative_path?(path)
          Pathname.new(path).relative?
        end
      end
    end
  end
end
