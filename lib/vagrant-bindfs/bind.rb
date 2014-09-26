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

        def default_options
          available_options.merge(
            available_shortcuts
          ).merge(
            available_flags
          ).merge(
            @machine.config.bindfs.default_options
          )
        end

        def normalize_options(current_options)
          source = current_options.delete(:source_path)
          dest = current_options.delete(:dest_path)
          options = default_options.merge(current_options)

          args = [].tap do |arg|
            options.each do |key, value|
              key = key.to_s.gsub "_", "-"

              if available_flags.include? key
                arg.push "--#{key}" if value
                next
              end

              next if value.nil?

              if available_shortcuts.include? key
                arg.push "-#{key} #{value}"
                next
              end

              if available_options.include? key
                arg.push "--#{key}='#{value}'"
                next
              end
            end
          end

          [
            source,
            dest,
            args.join(" ")
          ]
        end

        def bind_folders
          @env[:ui].info I18n.t("vagrant.config.bindfs.status.binding_all")

          binded_folders.each do |id, options|
            source, dest, args = normalize_options(options)

            bind_command = [
              "bindfs",
              args,
              source,
              dest
            ].compact

            unless @machine.communicate.test("test -d #{source}")
              @env[:ui].error I18n.t(
                "vagrant.config.bindfs.errors.source_path_not_exist",
                path: source
              )

              next
            end

            if @machine.communicate.test("mount | grep bindfs | grep #{dest}")
              @env[:ui].info I18n.t(
                "vagrant.config.bindfs.already_mounted",
                dest: dest
              )

              next
            end

            @env[:ui].info I18n.t(
              "vagrant.config.bindfs.status.binding_entry",
              dest: dest,
              source: source
            )

            @machine.communicate.tap do |comm|
              comm.sudo("mkdir -p #{dest}")

              comm.sudo(
                bind_command.join(" "),
                error_class: Error,
                error_key: :binding_failed
              )
            end
          end
        end

        def handle_bindfs_installation
          unless @machine.guest.capability(:bindfs_installed)
            @env[:ui].warn(I18n.t("vagrant.config.bindfs.not_installed"))

            unless @machine.guest.capability(:bindfs_install)
              raise Vagrant::Bindfs::Error, :cannot_install
            end
          end
        end


        def available_options
          @available_options ||= {
            "owner" => "vagrant",
            "group" => "vagrant",
            "perms" => "u=rwX:g=rD:o=rD",
            "mirror" => nil,
            "mirror-only" => nil,
            "create-for-user" => nil,
            "create-for-group" => nil,
            "create-with-perms" => nil
          }.freeze
        end

        def available_shortcuts
          @available_shortcuts ||= {
            "o" => nil
          }.freeze
        end

        def available_flags
          @available_flags ||= {
            "no-allow-other" => false,
            "create-as-user" => false,
            "create-as-mounter" => false,
            "chown-normal" => false,
            "chown-ignore" => false,
            "chown-deny" => false,
            "chgrp-normal" => false,
            "chgrp-ignore" => false,
            "chgrp-deny" => false,
            "chmod-normal" => false,
            "chmod-ignore" => false,
            "chmod-deny" => false,
            "chmod-allow-x" => false,
            "xattr-none" => false,
            "xattr-ro" => false,
            "xattr-rw" => false,
            "ctime-from-mtime" => false
          }.freeze
        end

      end
    end
  end
end
