require 'vagrant'
require 'vagrant/errors'
require 'vagrant/util/template_renderer'

module VagrantPlugins
  module Bindfs
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :default_options, :debug, :bind_folders

      def initialize
        @default_options = UNSET_VALUE
        @debug = UNSET_VALUE
        @bind_folders = {}
        @logger = Log4r::Logger.new('vagrantplugins::bindfs::config')
      end

      def default_options(new_values = {})
        @default_options = {} if @default_options == UNSET_VALUE
        @default_options.merge! new_values
      end

      def bind_folder(source_path, dest_path, options = {})
        options[:source_path] = source_path
        options[:dest_path] = dest_path
        options[:hook] ||= options.delete(:after) || VagrantPlugins::Bindfs::Plugin.hook_names.first

        @bind_folders[options[:dest_path]] = options
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

      def finalize!
        @default_options = {} if @default_options == UNSET_VALUE
        @debug = false if @debug == UNSET_VALUE
      end

      def validate!(machine)
        finalize!
        errors = []

        bind_folders.each do |id, options|
          next if options[:disabled]

          unless VagrantPlugins::Bindfs::Plugin.hook_names.include?(options[:hook].to_sym)
            errors << I18n.t(
                "vagrant.config.bindfs.errors.invalid_hook",
                hooks: VagrantPlugins::Bindfs::Plugin.hook_names
            )
          end

          if options[:dest_path].nil? or options[:source_path].nil?
            errors << I18n.t(
              "vagrant.config.bindfs.errors.no_path_supplied",
              path: options[:dest_path]
            )
          end

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

          unless Pathname.new(options[:dest_path]).to_path.match(/^\/vagrant/).nil?
            errors << I18n.t(
                "vagrant.config.bindfs.errors.destination_path_reserved",
                path: options[:dest_path]
            )
          end
        end

        if errors.any?
          rendered_errors = Vagrant::Util::TemplateRenderer.render(
            'config/validation_failed',
            errors: { 'vagrant-bindfs' => errors }
          )

          fail Vagrant::Errors::ConfigInvalid, errors: rendered_errors
        end
      end
    end
  end
end
