module VagrantBindfs
  module Vagrant
    module Capabilities
      module RedHat
        module PackageManager
          class << self

            def bindfs_package_manager_name(machine)
              "yum"
            end

          end
        end
      end
    end
  end
end
