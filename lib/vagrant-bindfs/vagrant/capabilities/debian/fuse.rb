# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module Fuse # :nodoc:
          class << self
            def bindfs_fuse_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('apt-get install -y fuse3')
            end
          end
        end
      end
    end
  end
end
