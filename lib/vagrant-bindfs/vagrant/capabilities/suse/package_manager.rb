module VagrantBindfs
  module Vagrant
    module Capabilities
      module Suse
        module PackageManager
          class << self

            def bindfs_package_manager_name(machine)
              "zypper"
            end

          end
        end
      end
    end
  end
end
