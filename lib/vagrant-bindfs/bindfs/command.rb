module VagrantBindfs
  module Bindfs
    class Command

      attr_reader :folder

      def initialize(folder)
        @folder = folder
      end

      def to_s
        [ "bindfs", arguments_for(folder.options).join(" "), folder.source, folder.destination ].compact.join(" ")
      end

      protected

      def arguments_for(options)
        options.reduce([]) do |args, (name, value)|
          args << format_argument(name, value) unless value.nil?
          args
        end.compact
      end

      def format_argument(name, value)
        definition      = argument_definition(name)
        compatible_name = argument_compatible_name(name)

        if definition['type'] == 'flag' && !!value
          return "-#{compatible_name}" if 0 == definition['long'].size # Shorthand only options
          return "--#{compatible_name}"
        end
        if definition['type'] == 'option'
          return "-#{compatible_name} #{value}" if 0 == definition['long'].size # Shorthand only options
          return "--#{compatible_name}=#{value}"
        end
      end

      def argument_definition(name)
        Bindfs::OptionSet.bindfs_options[name]
      end

      def argument_compatible_name(name)
        Bindfs::OptionSet.compatible_name_for_version(name, @folder.options.version)
      end

    end
  end
end
