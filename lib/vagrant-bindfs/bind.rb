module VagrantPlugins
  module Bindfs
    module Action
      class Bind
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
          
          @machine = env[:machine]

          unless binded_folders.empty?
            handle_bindfs_installation
            bind_folders
          end
        end

        def binded_folders
          @machine.config.bindfs.bind_folders
        end

        def default_options
          @@options.merge(@@flags).merge(@machine.config.bindfs.default_options)
        end
        
        def normalize_options opts
          source  = opts.delete(:source_path)
          dest    = opts.delete(:dest_path)
          opts    = default_options.merge(opts)

          args = []
          opts.each do |key, value|
            args << "--#{key.to_s}" if @@flags.key?(key) and !!value 
            args << "--#{key.to_s}=#{value}" if @@options.key?(key) and !value.nil?
          end
          
          [ source, dest, " #{args.join(" ")}" ]
        end

        def bind_folders
          @env[:ui].info I18n.t("vagrant.config.bindfs.status.binding_all")

          binded_folders.each do |id, opts|
            source, dest, args = normalize_options opts
            bind_command = "sudo bindfs#{args} #{source} #{dest}"
          
            unless @machine.communicate.test("test -d #{source}")
              @env[:ui].error(I18n.t('vagrant.config.bindfs.errors.source_path_not_exist', :path => source))
              next
            end

            if @machine.communicate.test("mount | grep bindfs | grep ' #{dest} '")
              @env[:ui].info(I18n.t('vagrant.config.bindfs.already_mounted', :dest => dest))
              next
            end

            @env[:ui].info I18n.t("vagrant.config.bindfs.status.binding_entry", :source => source, :dest => dest)

            @machine.communicate.sudo("mkdir -p #{dest}")
            @machine.communicate.sudo(bind_command, :error_class => Error, :error_key => :binding_failed)
          end
        end

        def handle_bindfs_installation
          if !@machine.guest.capability(:bindfs_installed)
            @env[:ui].warn(I18n.t('vagrant.config.bindfs.not_installed'))

            if !@machine.guest.capability(:bindfs_install)
              raise Vagrant::Bindfs::Error, :cannot_install
            end
          end
        end
        
      end #Bind
    end #Action
  end #Bindfs
end #VagrantPlugins
