module VagrantPlugins
  module Bindfs
    class Config < Vagrant.plugin("2", :config)

      def bind_folders
        @bind_folders ||= {}
      end

      def bind_folders=(new_values)
        @bind_folders = new_values
      end

      def default_options(new_values = {})
        @default_options ||= {}
        @default_options.merge! new_values
      end

      def bind_folder(source_path, dest_path, options = {})
        options[:source_path] = source_path
        options[:dest_path] = dest_path

        bind_folders[options[:dest_path]] = options
      end

      def merge(other)
        super.tap do |result|
          result.default_options(default_options(other.default_options))

          new_folders = bind_folders.dup
          other_folders = other.bind_folders

          other_folders.each do |id, options|
            new_folders[id] ||= {}
            new_folders[id].merge! options
          end

          result.bind_folders = new_folders
        end
      end

      def validate(machine)
        errors = []

        bind_folders.each do |id, options|
          next if options[:disabled]

          if Pathname.new(options[:dest_path]).relative?
            errors << I18n.t(
              "vagrant.config.bindfs.errors.destination_path_relative",
              path: options[:dest_path]
            )
          end

          if Pathname.new(options[:source_path]).relative?
            errors << I18n.t(
              "vagrant.config.bindfs.errors.source_path_relative",
              path: options[:source_path]
            )
          end
        end

        errors.empty? && {} || { "bindfs" => errors }
      end

    end
  end
end
