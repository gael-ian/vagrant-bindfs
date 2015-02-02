require "vagrant-bindfs/command"

module VagrantPlugins
  module Bindfs
    module Action
      class Bind
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

        def bind_folders
          @env[:ui].info I18n.t("vagrant.config.bindfs.status.binding_all")

          binded_folders.each do |id, options|

            command = VagrantPlugins::Bindfs::Command.new(@machine, options)

            unless @machine.communicate.test("test -d #{command.source}")
              @env[:ui].error I18n.t(
                "vagrant.config.bindfs.errors.source_path_not_exist",
                path: command.source
              )
              next
            end

            if @machine.communicate.test("mount | grep bindfs | grep #{command.destination}")
              @env[:ui].info I18n.t(
                "vagrant.config.bindfs.already_mounted",
                dest: command.destination
              )
              next
            end

            @env[:ui].info I18n.t(
              "vagrant.config.bindfs.status.binding_entry",
              dest: command.destination,
              source: command.source
            )

            @machine.communicate.tap do |comm|
              comm.sudo("mkdir -p #{command.destination}")
              comm.sudo(command.build, error_class: Error, error_key: :binding_failed)
              @env[:ui].info(command.build) if @machine.config.bindfs.debug
            end
          end
        end

        def handle_bindfs_installation
          unless @machine.guest.capability(:bindfs_installed)
            @env[:ui].warn(I18n.t("vagrant.config.bindfs.not_installed"))

            unless @machine.guest.capability(:install_bindfs)
              raise Vagrant::Bindfs::Error, :cannot_install
            end
          end

          unless @machine.guest.capability(:fuse_loaded)
            @env[:ui].warn(I18n.t("vagrant.config.bindfs.not_loaded"))

            unless @machine.guest.capability(:enable_fuse)
              raise Vagrant::Bindfs::Error, :cannot_enable_fuse
            end
          end
        end

      end
    end
  end
end
