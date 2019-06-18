# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    class Config < ::Vagrant.plugin('2', :config)
      attr_reader :debug

      attr_accessor :bindfs_version
      attr_reader :install_bindfs_from_source

      attr_reader :default_options
      attr_accessor :binded_folders

      attr_accessor :skip_validations
      attr_reader :force_empty_mountpoints

      def initialize
        @debug = false

        @bindfs_version = UNSET_VALUE
        @install_bindfs_from_source = false

        @binded_folders = {}
        @default_options = Bindfs::OptionSet.new(nil,
                                                 'force-user' => 'vagrant',
                                                 'force-group' => 'vagrant',
                                                 'perms' => 'u=rwX:g=rD:o=rD')

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

      def binded_folder=(*_any_variant)
        raise VagrantBindfs::Vagrant::ConfigError, :binded_folders
      end

      def bind_folder(source, destination, options = {})
        hook = options.delete(:after) || :synced_folders
        folder = Bindfs::Folder.new(hook, source, destination, options)
        @binded_folders[folder.id] = folder
      end

      def merge(other) # rubocop:disable Metrics/AbcSize
        super.tap do |result|
          result.debug = (debug || other.debug)

          result_bindfs_version = [bindfs_version, other.bindfs_version].reject { |v| v == UNSET_VALUE }.min
          result.bindfs_version = result_bindfs_version unless result_bindfs_version.nil?
          result.install_bindfs_from_source = (install_bindfs_from_source || other.install_bindfs_from_source)

          result.default_options = default_options.merge(other.default_options)
          result.binded_folders = binded_folders.merge(other.binded_folders)

          result.skip_validations = (skip_validations + other.skip_validations).uniq
          result.force_empty_mountpoints = (force_empty_mountpoints || other.force_empty_mountpoints)
        end
      end

      def finalize!
        @bindfs_version = :latest if @bindfs_version == UNSET_VALUE
      end

      def validate(_machine)
        errors = _detected_errors

        binded_folders.each_value do |folder|
          validator = Bindfs::Validators::Config.new(folder)
          errors << validator.errors unless validator.valid?
        end

        { 'vagrant-bindfs' => errors.flatten }
      end
    end
  end
end
