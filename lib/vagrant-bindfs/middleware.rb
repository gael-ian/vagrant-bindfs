module VagrantBindfs
  # A Vagrant middleware which use bindfs to relocate directories inside a VM
  # and change their owner, group and permission.
  class Middleware
    
    # Options
    @@options = {
      :owner                => 'vagrant',
      :group                => 'vagrant',
      :perms                => 'u=rwX:g=rD:o=rD',
      :mirror               => nil,
      :'mirror-only'        => nil,
      :'create-for-user'    => nil,
      :'create-for-group'   => nil,
      :'create-with-perms'  => nil,
    }
      
    # Flags
    @@flags = {
      :'no-allow-other'     => false,
      :'create-as-user'     => false,
      :'create-as-mounter'  => false,
      :'chown-normal'       => false,
      :'chown-ignore'       => false,
      :'chown-deny'         => false,
      :'chgrp-normal'       => false,
      :'chgrp-ignore'       => false,
      :'chgrp-deny'         => false,
      :'chmod-normal'       => false,
      :'chmod-ignore'       => false,
      :'chmod-deny'         => false,
      :'chmod-allow-x'      => false,
      :'xattr-none'         => false,
      :'xattr-ro'           => false,
      :'xattr-rw'           => false,
      :'ctime-from-mtime'   => false,
    }
    
    def initialize(app, env)
      @app = app
      @env = env
    end

    def call(env)
      @app.call(env)
      @env = env
      
      bind_folders if !binded_folders.empty? and bindfs_supported?
    end

    def binded_folders
      @env[:vm].config.bindfs.binded_folders
    end

    def default_options
      @@options.merge(@@flags).merge(@env[:vm].config.bindfs.default_options)
    end
    
    def bindfs_supported?
      @env[:vm].channel.execute("bindfs --help", :error_class => Error, :error_key => :not_installed)
    end
    
    def normalize_options opts
      
      path     = opts.delete(:path)
      bindpath = opts.delete(:bindpath)
      opts     = default_options.merge(opts)

      args = []
      opts.each do |key, value|
        args << "--#{key.to_s}" if @@flags.key?(key) and !!value 
        args << "--#{key.to_s}=#{value}" if @@options.key?(key) and !value.nil?
      end
      
      [ path, bindpath, " #{args.join(" ")}" ]
    end

    def bind_folders
      @env[:ui].info I18n.t("vagrant.guest.linux.bindfs.status.binding")
      binded_folders.each do |opts|
          
        path, bindpath, args = normalize_options opts
        
        @env[:vm].channel.sudo("mkdir -p #{bindpath}")
        @env[:vm].channel.sudo("sudo bindfs#{args} #{path} #{bindpath}", :error_class => Error, :error_key => :bindfs_command_fail)
        @env[:ui].info I18n.t("vagrant.guest.linux.bindfs.status.binding_entry", :path => path, :bindpath => bindpath)
        
      end
    end
    
  end
end