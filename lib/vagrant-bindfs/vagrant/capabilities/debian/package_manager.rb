# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module PackageManager
          class << self
            def bindfs_package_manager_name(_machine)
              'apt-get'
            end

            def bindfs_package_manager_update(machine)
              machine.communicate.sudo('apt-get update')
            end
          end
        end
      end
    end
  end
end
