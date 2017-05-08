# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Suse
        module PackageManager
          class << self
            def bindfs_package_manager_name(_machine)
              'zypper'
            end

            def bindfs_package_manager_update(machine)
              machine.communicate.sudo('zypper ref -s')
            end
          end
        end
      end
    end
  end
end
