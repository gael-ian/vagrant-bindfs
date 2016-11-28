module VagrantBindfs
  module Vagrant
    module Actions
      class Installer

        attr_reader :app
        attr_reader :env

        include Concerns::Machine
        include Concerns::Log

        def initialize(app, env)
          @app  = app
          @env  = env
        end

        def call(env)
          @app.call(env)
          apply!(env)
        end

        protected

        def apply!(env)
          return if binded_folders.empty?
          ensure_guest_is_ready_to_bind!
        end

        def ensure_guest_is_ready_to_bind!
          info(I18n.t("vagrant-bindfs.actions.installer.start"))
          ensure_package_manager_is_installed!
          ensure_fuse_is_installed!
          ensure_fuse_is_loaded!
          ensure_bindfs_is_installed!
          info(I18n.t("vagrant-bindfs.actions.installer.end"))
        end

        def ensure_package_manager_is_installed!
          unless guest.capability(:bindfs_package_manager_installed)
            warn(I18n.t("vagrant-bindfs.actions.package_manager.not_installed"))
            unless guest.capability(:bindfs_package_manager_install)
              raise VagrantBindfs::Error, :cannot_install
            end
          end

          detail(I18n.t(
            "vagrant-bindfs.actions.package_manager.installed",
            name: guest.capability(:bindfs_package_manager_name)
          ))
        end

        def ensure_fuse_is_installed!
          unless guest.capability(:bindfs_fuse_installed)
            warn(I18n.t("vagrant-bindfs.actions.fuse.not_installed"))
            unless guest.capability(:bindfs_fuse_install)
              raise VagrantBindfs::Error, :cannot_install
            end
          end

          detail(I18n.t("vagrant-bindfs.actions.fuse.installed"))
        end

        def ensure_fuse_is_loaded!
          unless guest.capability(:bindfs_fuse_loaded)
            warn(I18n.t("vagrant-bindfs.actions.fuse.not_loaded"))
            unless guest.capability(:bindfs_fuse_load)
              raise VagrantBindfs::Error, :cannot_load
            end
          end

          detail(I18n.t("vagrant-bindfs.actions.fuse.loaded"))
        end

        def ensure_bindfs_is_installed!
          unless guest.capability(:bindfs_bindfs_installed)
            warn(I18n.t("vagrant-bindfs.actions.bindfs.not_installed"))
            unless guest.capability(:bindfs_bindfs_install)
              raise VagrantBindfs::Error, :cannot_install
            end
          end

          detail(I18n.t(
            "vagrant-bindfs.actions.bindfs.detected",
            version: guest.capability(:bindfs_bindfs_version)
          ))
        end

      end
    end
  end
end
