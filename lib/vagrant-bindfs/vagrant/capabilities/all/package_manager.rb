# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module All
        module PackageManager
          class << self
            def bindfs_package_manager_installed(machine)
              package_manager_name = machine.guest.capability(:bindfs_package_manager_name)
              machine.communicate.test("#{package_manager_name} --help")
            end
          end
        end
      end
    end
  end
end
