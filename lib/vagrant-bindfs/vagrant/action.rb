module VagrantBindfs
  module Vagrant
    class Action

      def initialize(app, env, hook)
        @app  = app
        @env  = env
        @hook = hook
      end

      def call(env)
        @app.call(env)
        apply!(env)
      end

      protected

      def apply!(env)
        @env      = env
        @machine  = env[:machine]

        return if binded_folders.empty?

        ensure_guest_is_ready_to_bind!
        bind_folders!
      end

      def binded_folders
        @binded_folders ||= begin
          @machine.config.bindfs.binded_folders.reduce({}) do |binded, (id, folder)|
            binded[id] = folder if folder.hook == @hook
            binded
          end
        end
      end

      def ensure_guest_is_ready_to_bind!
        ensure_package_manager_is_installed!
        ensure_fuse_is_installed!
        ensure_fuse_is_loaded!
        ensure_bindfs_is_installed!
      end

      def ensure_package_manager_is_installed!
        if @machine.guest.capability(:bindfs_package_manager_installed)
          @env[:ui].info(I18n.t(
            "vagrant-bindfs.capabilities.package_manager.detected",
            name: @machine.guest.capability(:bindfs_package_manager_name)
          ))
          return
        end

        @env[:ui].warn(I18n.t("vagrant-bindfs.capabilities.package_manager.not_installed"))
        unless @machine.guest.capability(:bindfs_package_manager_install)
          raise VagrantBindfs::Error, :cannot_install
        end
      end

      def ensure_fuse_is_installed!
        return if @machine.guest.capability(:bindfs_fuse_installed)
        @env[:ui].warn(I18n.t("vagrant-bindfs.capabilities.fuse.not_installed"))
        unless @machine.guest.capability(:bindfs_fuse_install)
          raise VagrantBindfs::Error, :cannot_install
        end
      end

      def ensure_fuse_is_loaded!
        return if @machine.guest.capability(:bindfs_fuse_loaded)
        @env[:ui].warn(I18n.t("vagrant-bindfs.capabilities.fuse.not_loaded"))
        unless @machine.guest.capability(:bindfs_fuse_load)
          raise VagrantBindfs::Error, :cannot_install
        end
      end

      def ensure_bindfs_is_installed!
        return if @machine.guest.capability(:bindfs_bindfs_installed)
        @env[:ui].warn(I18n.t("vagrant-bindfs.capabilities.bindfs.not_installed"))
        unless @machine.guest.capability(:bindfs_bindfs_install)
          raise VagrantBindfs::Error, :cannot_install
        end
      end

      def bind_folders!

        bindfs_version = @machine.guest.capability(:bindfs_bindfs_version)
        @env[:ui].info I18n.t("vagrant-bindfs.capabilities.bindfs.detected", version: bindfs_version)
        @env[:ui].info I18n.t("vagrant.config.bindfs.status.binding_all")

        binded_folders.each do |_, folder|

          folder.reverse_merge!(@machine.config.bindfs.default_options)
          folder.to_version!(bindfs_version)

          validator = VagrantBindfs::Bindfs::Validator.new(folder, @machine)

          unless validator.valid?
            @env[:ui].error I18n.t(
              "vagrant-bindfs.validations.errors_found",
              dest:   folder.destination,
              source: folder.source,
              errors: validator.errors.join(' ')
            )
            next
          end

          command = VagrantBindfs::Bindfs::Command.new(folder)

          @env[:ui].info I18n.t(
            "vagrant.config.bindfs.status.binding_entry",
            dest: folder.destination,
            source: folder.source
          )

          @machine.communicate.tap do |comm|
            comm.sudo("mkdir -p #{folder.destination}")
            comm.sudo(command.to_s, error_class: VagrantBindfs::Vagrant::Error, error_key: :binding_failed)
            @env[:ui].info(command.to_s) if @machine.config.bindfs.debug
          end
        end
      end

    end
  end
end
