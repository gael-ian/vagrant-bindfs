# frozen_string_literal: true

module VagrantBindfs
  module Bindfs
    class Command
      attr_reader :folder

      def initialize(folder)
        @folder = folder
      end

      def to_s(bindfs_command = 'bindfs')
        [bindfs_command, arguments_for(folder.options).join(' '), folder.source, folder.destination].compact.join(' ')
      end

      protected

      def arguments_for(options)
        options.each_with_object([]) do |(name, value), args|
          args << format_argument(name, value) unless value.nil?
          args
        end.compact
      end

      def format_argument(name, value)
        send("format_#{argument_type(name)}", name, value)
      end

      def format_flag(name, value)
        return unless !!value
        compatible_name = argument_compatible_name(name)
        (argument_shorthand_only?(name) ? "-#{compatible_name}" : "--#{compatible_name}")
      end

      def format_option(name, value)
        compatible_name = argument_compatible_name(name)
        (argument_shorthand_only?(name) ? "-#{compatible_name} #{value}" : "--#{compatible_name}=#{value}")
      end

      def argument_type(name)
        argument_definition(name)['type']
      end

      def argument_shorthand_only?(name)
        argument_definition(name)['long'].empty?
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
