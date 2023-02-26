# frozen_string_literal: true

require 'forwardable'

module VagrantBindfs
  module Bindfs
    module Validators
      class Config # :nodoc:
        attr_reader :folder,
                    :errors

        extend ::Forwardable
        def_delegators :@folder, :source, :destination, :options

        def initialize(folder)
          @folder = folder
          @errors = []
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
          @errors << invalid('source_path_required') if source.empty?
          @errors << invalid('path_must_be_absolute', path: source) if relative_path?(source)
        end

        def validate_destination!
          @errors << invalid('destination_path_required') if destination.empty?
          @errors << invalid('path_must_be_absolute', path: destination) if relative_path?(destination)
        end

        def validate_options!
          folder.options.invalid_options.each_key do |option_name|
            @errors << deprecation(option_name.tr('-', '_'))
          end
        end

        def relative_path?(path)
          Pathname.new(path).relative?
        end

        def invalid(key, **options)
          I18n.t(key, **options.merge(scope: 'vagrant-bindfs.validations'))
        end

        def deprecation(key)
          I18n.t(key, scope: 'vagrant-bindfs.deprecations')
        end
      end
    end
  end
end
