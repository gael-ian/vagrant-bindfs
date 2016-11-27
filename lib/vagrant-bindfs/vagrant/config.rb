module VagrantBindfs
  module Vagrant
    class Config < ::Vagrant.plugin("2", :config)

      attr_accessor :debug

      attr_accessor :source_version

      attr_accessor :default_options
      attr_accessor :binded_folders


      def initialize
        @debug            = false

        @source_version   = UNSET_VALUE

        @binded_folders   = {}
        @default_options  = Bindfs::OptionSet.new(nil, {
          'force-user'  => 'vagrant',
          'force-group' => 'vagrant',
          'perms'       => 'u=rwX:g=rD:o=rD'
        })
      end

      def debug=(value)
        @debug = (value == true)
      end

      def source_version=(value)
        @source_version = Gem::Version.new(value.to_s)
      end

      def default_options=(options = {})
        @default_options = Bindfs::OptionSet.new(nil, options)
      end

      def binded_folder=
        # TODO: raise error and try to convert to call to bind_folder
      end

      def bind_folder(source, destination, options = {})
        hook = options.delete(:after) || :synced_folders
        folder = Bindfs::Folder.new(hook, source, destination, options)
        @binded_folders[folder.id] = folder
      end


      def merge(other)
        super.tap do |result|
          result.debug            = (debug || other.debug)
          result.default_options  = default_options.merge(other.default_options)
          result.binded_folders   = binded_folders.merge(other.binded_folders)
          source_version          = [ source_version, other.source_version ].select{ |v| v != UNSET_VALUE }.min
          result.source_version   =  source_version unless source_version.nil?
        end
      end

      def finalize!
        @source_version = Gem::Version.new(VagrantBindfs::SOURCE_VERSION) if @source_version == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        binded_folders.each do |_, folder|
          validator = Bindfs::Validator.new(folder, machine)
          errors << validator.errors unless validator.valid?
        end

        { 'vagrant-bindfs' => errors.flatten }
      end

    end
  end
end
