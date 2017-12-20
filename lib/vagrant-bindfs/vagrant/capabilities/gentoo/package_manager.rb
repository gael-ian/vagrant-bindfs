# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Gentoo
        module PackageManager
          class << self
            def bindfs_package_manager_name(_machine)
              'emerge'
            end

            def bindfs_package_manager_update(machine)
              machine.communicate.sudo('emaint -a sync')
            end
          end
        end
      end
    end
  end
end
