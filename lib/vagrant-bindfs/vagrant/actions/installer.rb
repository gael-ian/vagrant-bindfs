# frozen_string_literal: true
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

        def apply!(_env)
          return if binded_folders.empty?
          ensure_guest_is_ready_to_bind!
        end

        def ensure_guest_is_ready_to_bind!
          info(I18n.t('vagrant-bindfs.actions.installer.start'))
          ensure_package_manager_is_installed!
          ensure_fuse_is_installed!
          ensure_fuse_is_loaded!
          ensure_bindfs_is_installed!
          info(I18n.t('vagrant-bindfs.actions.installer.end'))
        end

        def ensure_package_manager_is_installed!
          unless guest.capability(:bindfs_package_manager_installed)
            warn(I18n.t('vagrant-bindfs.actions.package_manager.not_installed'))
            guest.capability(:bindfs_package_manager_install)
          end

          detail(I18n.t('vagrant-bindfs.actions.package_manager.installed',
                        name: guest.capability(:bindfs_package_manager_name)))
        end

        def ensure_fuse_is_installed!
          unless guest.capability(:bindfs_fuse_installed)
            warn(I18n.t('vagrant-bindfs.actions.fuse.not_installed'))
            guest.capability(:bindfs_fuse_install)
          end

          detail(I18n.t('vagrant-bindfs.actions.fuse.installed'))
        end

        def ensure_fuse_is_loaded!
          unless guest.capability(:bindfs_fuse_loaded)
            warn(I18n.t('vagrant-bindfs.actions.fuse.not_loaded'))
            guest.capability(:bindfs_fuse_load)
          end

          detail(I18n.t('vagrant-bindfs.actions.fuse.loaded'))
        end

        def ensure_bindfs_is_installed!
          unless guest.capability(:bindfs_bindfs_installed)
            warn(I18n.t('vagrant-bindfs.actions.bindfs.not_installed'))
            install_bindfs!
          end

          detail(I18n.t('vagrant-bindfs.actions.bindfs.detected',
                        version: guest.capability(:bindfs_bindfs_version)))
        end

        def install_bindfs!
          return install_bindfs_from_source! if install_from_source?
          return guest.capability(:bindfs_bindfs_install) if install_latest_from_repositories?
          return guest.capability(:bindfs_bindfs_install_version, config.bindfs_version) if install_version_from_repositories?

          warn(I18n.t('vagrant-bindfs.actions.bindfs.not_found_in_repository',
                      version: config.bindfs_version))
          install_bindfs_from_source!
        end

        def install_bindfs_from_source!
          version = (config.bindfs_version == :latest ? VagrantBindfs::Bindfs::SOURCE_VERSION : config.bindfs_version.to_s)
          guest.capability(:bindfs_bindfs_install_compilation_requirements)
          guest.capability(:bindfs_bindfs_install_from_source, version)
        end

        protected

        def install_from_source?
          config.install_bindfs_from_source
        end

        def install_latest_from_repositories?
          config.bindfs_version == :latest && guest.capability(:bindfs_bindfs_search)
        end

        def install_version_from_repositories?
          config.bindfs_version != :latest && guest.capability(:bindfs_bindfs_search_version, config.bindfs_version)
        end

      end
    end
  end
end
