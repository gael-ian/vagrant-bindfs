# frozen_string_literal: true

require 'forwardable'

module VagrantBindfs
  module Bindfs
    class OptionSet
      attr_reader :version

      attr_reader :options
      attr_reader :invalid_options
      attr_reader :unsupported_options

      include ::Enumerable
      extend ::Forwardable
      def_delegators :@options, :each, :[], :keys, :key?

      def initialize(version = nil, options = {})
        @version              = version
        @options              = normalize_option_names(options)
        @invalid_options      = {}
        @unsupported_options  = {}

        extract_invalid_options!
        extract_unsupported_options!
        cast_option_values!
      end

      def merge!(other)
        other = other.to_version(version) if other.respond_to?(:to_version)
        @options.merge!(normalize_option_names(other))

        extract_invalid_options!
        extract_unsupported_options!
        cast_option_values!
      end

      def merge(other)
        dup.tap { |result| result.merge!(other) }
      end

      def to_version(new_version)
        self.class.new(new_version, @options.merge(invalid_options).merge(unsupported_options))
      end

      protected

      def normalize_option_names(options)
        options.each_with_object({}) do |(key, value), normalized|
          normalized_key = key.to_s.tr('_', '-')
          canonical_name = canonical_option_name(normalized_key)

          if normalized.key?(canonical_name)
            raise VagrantBindfs::Vagrant::ConfigError.new(:conflicting_options, name: canonical_name)
          end

          normalized[canonical_name] = value
          normalized
        end
      end

      def canonical_option_name(option_name)
        self.class.bindfs_options.each do |name, definition|
          return name if definition['short'].include?(option_name)
          return name if definition['long'].include?(option_name)
        end
        option_name
      end

      def extract_invalid_options!
        extract_options_by_names!(options.keys - self.class.bindfs_options.keys, @invalid_options)
      end

      def extract_unsupported_options!
        extract_options_by_names!(options.keys - self.class.supported_options(version).keys, @unsupported_options)
      end

      def extract_options_by_names!(names, to)
        return {} if names.empty?
        names.each { |name| to[name] = @options.delete(name) }
      end

      def cast_option_values!
        @options = options.each_with_object({}) do |(key, value), normalized|
          normalized[key] = case self.class.bindfs_options[key]['type']
                            when 'option' then cast_value_as_option(value)
                            when 'flag'   then cast_value_as_flag(value)
                            end
          normalized
        end
      end

      def cast_value_as_option(value)
        return nil if value.respond_to?(:nil?) && value.nil?
        (value.respond_to?(:to_s) ? value.to_s : value)
      end

      def cast_value_as_flag(value)
        return true if [true, 'true', 'True', 'yes', 'Yes', 'y', 'Y', 'on', 'On', 1].include?(value)
        return false if [false, 'false', 'False', 'no', 'No', 'n', 'N', 'off', 'Off', 0].include?(value)
        !!value
      end

      class << self
        def bindfs_options
          @bindfs_options ||= JSON.parse(File.read(File.expand_path('../option_definitions.json', __FILE__)))
        end

        def supported_options(version)
          bindfs_options.each_with_object({}) do |(name, definition), supported|
            supported[name] = definition if version.nil? || !version_lower_than(version, definition['since'])
            supported
          end
        end

        def compatible_name_for_version(option_name, version)
          return 'user'   if option_name == 'force-user' && version_lower_than(version, '1.12')
          return 'group'  if option_name == 'force-group' && version_lower_than(version, '1.12')
          option_name
        end

        protected

        def version_lower_than(version, target)
          Gem::Version.new(version) < Gem::Version.new(target)
        end
      end
    end
  end
end
