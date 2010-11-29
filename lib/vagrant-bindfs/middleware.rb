module VagrantBindfs
  # A Vagrant middleware which use bindfs to relocate directories inside a VM
  # and change their owner, group and permission.
  class Middleware
    
    # Options
    @@options = {
      :owner              => 'vagrant',
      :group              => 'vagrant',
      :perms              => 'u=rwD:g=rD:o=rD',
      :mirror             => nil,
      :mirror_only        => nil,
      :no_allow_other     => nil,
      :create_for_user    => nil,
      :create_for_group   => nil,
      :create_with_perms  => nil,
    }
      
    # Flags
    @@flags = {
      :create_as_user     => false,
      :create_as_mounter  => false,
      :chown_normal       => false,
      :chown_ignore       => false,
      :chown_deny         => false,
      :chgrp_normal       => false,
      :chgrp_ignore       => false,
      :chgrp_deny         => false,
      :chmod_normal       => false,
      :chmod_ignore       => false,
      :chmod_deny         => false,
      :chmod_allow_x      => false,
      :xattr_none         => false,
      :xattr_ro           => false,
      :xattr_rw           => false,
      :ctime_from_mtime   => false,
    }
    
    def initialize(app, env)
      @app = app
      @env = env
    end

    def call(env)
      @env = env
      @app.call(env)
      bind_folders if !binded_folders.empty?
    end

    def binded_folders
      @env.env.config.bindfs.binded_folders
    end

    def default_options
      @@options.merge(@@flags).merge(@env.env.config.bindfs.default_options || {})
    end

    def bind_folders
      @env.ui.info I18n.t("vagrant.actions.vm.bind_folders.binding")
      @env["vm"].ssh.execute do |ssh|
        binded_folders.each do |opts|

          path     = opts.delete(:path)
          bindpath = opts.delete(:bindpath)
          opts     = default_options.merge(opts)

          args = []
          opts.each do |key, value|
            opt = key.to_s
            opt.sub!(/_/, '-')
            
            if @@flags.key?(key)
              args << "--#{opt}" if !!value 
            else
              args << "--#{opt}=#{value}" if !value.nil?
            end
          end
          args = " #{args.join(" ")}"

          @env.ui.info I18n.t("vagrant.actions.vm.bind_folders.binding_entry",
            :path     => path,
            :bindpath => bindpath
            )
          ssh.exec!("sudo mkdir -p #{bindpath}")
          ssh.exec!("sudo bindfs#{args} #{path} #{bindpath}")
        end
      end
    end
  end
end