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
          unless @machine.communicate.test('bindfs --help')
            @machine.env.ui.error(I18n.t('vagrant.config.bindfs.not_supported'))
          else
            @machine.env.ui.info(I18n.t('vagrant.config.bindfs.status.binding_all'))
            bind_folders if !binded_folders.empty?
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
          @env[:ui].info I18n.t("vagrant.guest.linux.bindfs.status.binding")
          binded_folders.each do |opts|
            source, dest, args = normalize_options opts
          
            unless machine.communicate.test("test -d #{source}")
              @env.ui.error(I18n.t('vagrant.config.bindfs.source_path_notexist', :path => source))
              next
            end

            @env[:vm].communicate.sudo("mkdir -p #{dest}")
            @env[:vm].communicate.sudo("sudo bindfs#{args} #{source} #{dest}", :error_class => Error, :error_key => :bindfs_command_fail)
            @env[:ui].info I18n.t("vagrant.guest.linux.bindfs.status.binding_entry", :source => source, :dest => dest)
            
          end
        end
        
      end #Bind
    end #Action
  end #Bindfs
end #VagrantPlugins
