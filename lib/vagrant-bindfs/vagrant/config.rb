# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    class Config < ::Vagrant.plugin('2', :config)
      DEFAULT_OPTIONS = {
        'force-user' => 'vagrant',
        'force-group' => 'vagrant',
        'perms' => 'u=rwX:g=rD:o=rD'
      }.freeze

      attr_reader :debug,
                  :install_bindfs_from_source,
                  :default_options,
                  :force_empty_mountpoints

      attr_accessor :bindfs_version,
                    :bound_folders,
                    :skip_validations

      def initialize # rubocop:disable Lint/MissingSuper
        @debug = false

        @bindfs_version = UNSET_VALUE
        @install_bindfs_from_source = false

        @bound_folders = {}
        @default_options = UNSET_VALUE

        @skip_validations = []
        @force_empty_mountpoints = false
      end

      def debug=(value)
        @debug = (value == true)
      end

      def source_version=(value)
        @bindfs_version = Gem::Version.new(value.to_s)
      end

      def install_bindfs_from_source=(value)
        @install_bindfs_from_source = (value == true)
      end

      def default_options=(options = {})
        @default_options = Bindfs::OptionSet.new(nil, options)
      end

      def force_empty_mountpoints=(value)
        @force_empty_mountpoints = (value == true)
      end

      def bound_folder=(*_any_variant)
        raise VagrantBindfs::Vagrant::ConfigError, :bound_folders
      end

      def bind_folder(source, destination, options = {})
        hook = options.delete(:after) || :synced_folders
        folder = Bindfs::Folder.new(hook, source, destination, options)
        @bound_folders[folder.id] = folder
      end

      def merge(other) # rubocop:disable Metrics/AbcSize
        super.tap do |result|
          %i[debug force_empty_mountpoints install_bindfs_from_source].each do |boolean|
            result.send("#{boolean}=", (send(boolean) || other.send(boolean)))
          end
          result.bound_folders = bound_folders.merge(other.bound_folders)
          result.skip_validations = (skip_validations + other.skip_validations).uniq

          result.bindfs_version = merge_bindfs_version(other) unless merge_bindfs_version(other) == UNSET_VALUE
          result.default_options = merge_default_options(other) unless merge_default_options(other) == UNSET_VALUE
        end
      end

      def finalize!
        @bindfs_version = :latest if @bindfs_version == UNSET_VALUE
        self.default_options = DEFAULT_OPTIONS if default_options == UNSET_VALUE
      end

      def validate(_machine)
        errors = _detected_errors

        bound_folders.each_value do |folder|
          validator = Bindfs::Validators::Config.new(folder)
          errors << validator.errors unless validator.valid?
        end

        { 'vagrant-bindfs' => errors.flatten }
      end

      protected

      def merge_bindfs_version(other)
        return other.bindfs_version if bindfs_version == UNSET_VALUE
        return bindfs_version if other.bindfs_version == UNSET_VALUE

        [bindfs_version, other.bindfs_version].reject { |v| v == UNSET_VALUE }.min
      end

      def merge_default_options(other)
        return other.default_options if default_options == UNSET_VALUE
        return default_options if other.default_options == UNSET_VALUE

        default_options.merge(other.default_options)
      end
    end
  end
end
