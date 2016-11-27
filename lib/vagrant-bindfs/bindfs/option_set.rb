module VagrantBindfs
  module Bindfs
    class OptionSet

      attr_reader :version

      attr_reader :options
      attr_reader :invalid_options
      attr_reader :unsupported_options


      include Enumerable
      extend Forwardable
      [:each, :[], :keys, :key? ].each do |method|
        def_delegator :@options, method
      end


      def initialize(version = nil, options = {})
        @version              = version
        @options              = normalize_option_names(options)
        @invalid_options      = {}
        @unsupported_options  = {}

        extract_invalid_options!
        extract_unsupported_options!
      end

      def merge!(other)
        other = other.to_version(version) if other.respond_to?(:to_version)
        @options.merge!(normalize_option_names(other))
        extract_invalid_options!
        extract_unsupported_options!
      end

      def merge(other)
        self.dup.tap{ |result| result.merge!(other) }
      end

      def to_version(new_version)
        self.class.new(new_version, @options.merge(invalid_options).merge(unsupported_options))
      end

      protected

      def normalize_option_names(options)
        options.reduce({}) do |normalized, (key, value)|
          normalized_key = key.to_s.gsub("_", "-")
          canonical_name = canonical_option_name(normalized_key)

          # TODO: raise error on conflicting option names
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
        names.each{ |name| to[name] = @options.delete(name) }
      end

      class << self

        def bindfs_options
          @bindfs_options ||= JSON.parse(File.read(File.expand_path("../option_definitions.json", __FILE__)))
        end

        def supported_options(version)
          bindfs_options.reduce({}) do |supported, (name, definition)|
            supported[name] = definition if version.nil? || !version_lower_than(version, definition['since'])
            supported
          end
        end

        def compatible_name_for_version(option_name, version)
          # TODO: raise an error if version.nil? ?
          return 'user'   if option_name == 'force-user' && version_lower_than(version, "1.12")
          return 'group'  if option_name == 'force-group' && version_lower_than(version, "1.12")
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
