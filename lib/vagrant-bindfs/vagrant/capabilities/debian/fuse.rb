# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module Fuse
          class << self
            def bindfs_fuse_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('apt-get install -y fuse')
            end
          end
        end
      end
    end
  end
end
