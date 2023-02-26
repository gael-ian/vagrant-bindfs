# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Gentoo
        module Fuse # :nodoc:
          class << self
            def bindfs_fuse_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('emerge sys-fs/fuse')
            end
          end
        end
      end
    end
  end
end
