module VagrantBindfs
  # A configuration class to configure defaults which are used for
  # the `vagrant-bindfs` plugin.
  class Config < Vagrant::Config::Base
    configures :bindfs

    attr_accessor :default_options
    attr_reader :binded_folders

    def initialize
      @binded_folders = []
      @default_options = nil
    end

    def bind_folder(path, bindpath, opts=nil)
      @binded_folders << {
        :path => path,
        :bindpath => bindpath
      }.merge(opts || {})
    end

    def validate(errors)
    end
  end
end