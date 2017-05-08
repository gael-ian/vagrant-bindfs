# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module RedHat
        module PackageManager
          class << self
            def bindfs_package_manager_name(_machine)
              'yum'
            end

            def bindfs_package_manager_update(machine)
              machine.communicate.sudo('yum clean expire-cache')
            end
          end
        end
      end
    end
  end
end
