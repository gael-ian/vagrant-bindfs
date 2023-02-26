# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin
        module Fuse # :nodoc:
          class << self
            def bindfs_fuse_installed(machine)
              machine.communicate.test('test -d /Library/Frameworks/OSXFUSE.framework/')
            end

            def bindfs_fuse_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.execute('brew tap caskroom/cask && brew cask install osxfuse')
            end

            # OSXFuse is automatically loaded.
            # Just check if it is installed

            def bindfs_fuse_loaded(machine)
              machine.guest.capability(:bindfs_fuse_installed)
            end

            def bindfs_fuse_load(machine)
              machine.guest.capability(:bindfs_fuse_installed)
            end
          end
        end
      end
    end
  end
end
