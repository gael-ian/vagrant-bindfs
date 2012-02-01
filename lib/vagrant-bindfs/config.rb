module VagrantBindfs
  # A configuration class to configure defaults which are used for
  # the `vagrant-bindfs` plugin.
  class Config < Vagrant::Config::Base

    attr_writer :default_options,
                :binded_folders
    
    def default_options
      @default_options || {}
    end
    
    def binded_folders
      @binded_folders || []
    end

    def bind_folder(path, bindpath, opts = {})
      @binded_folders = [] unless instance_variable_defined?(:@binded_folders)
      @binded_folders << {
        :path     => path,
        :bindpath => bindpath
      }.merge(opts)
    end
    
  end
end