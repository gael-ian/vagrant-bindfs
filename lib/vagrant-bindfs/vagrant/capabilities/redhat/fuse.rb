# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module RedHat
        module Fuse
          class << self
            def bindfs_fuse_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('yum -y install fuse')
            end
          end
        end
      end
    end
  end
end
