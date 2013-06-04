module VagrantPlugins
  module Bindfs
    class Config < Vagrant.plugin('2', :config)

      def initialize
        @__default_options = {}
        @__bind_folders = {}
      end

      def bind_folders
        @__bind_folders
      end

      def default_options(new_options = {})
        @__default_options.merge! new_options
      end

      def bind_folder(source_path, dest_path, options = nil)
        options ||= {}
        options[:source_path] = source_path
        options[:dest_path] = dest_path

        @__bind_folders[options[:dest_path]] = options
      end

      def merge(other)
        super.tap do |result|
          # merge the changes to default options
          result.instance_variable_set(
            :@__default_options, default_options(other.default_options))

          # merge the folders to be bound
          new_folders = @__bind_folders.dup
          other_folders = other.instance_variable_get(:@__bind_folders)

          other_folders.each do |id, options|
            new_folders[id] ||= {}
            new_folders[id].merge!(options)
          end

          result.instance_variable_set(:@__bind_folders, new_folders)
        end
      end

      def validate(machine)
        errors = []

        @__bind_folders.each do |id, options|
          next if options[:disabled]

          if Pathname.new(options[:dest_path]).relative?
            errors << I18n.t('vagrant.config.bindfs.errors.destination_path_relative',
              :path => options[:dest_path])
          end

          if Pathname.new(options[:source_path]).relative?
            errors << I18n.t('vagrant.config.bindfs.errors.source_path_relative',
              :path => options[:source_path])
          end
        end

        errors.empty? && {} || { 'bindfs' => errors }
      end
    end
  end
end
