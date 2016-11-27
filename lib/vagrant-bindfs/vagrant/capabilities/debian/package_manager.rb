module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module PackageManager
          class << self

            def bindfs_package_manager_name(machine)
              "apt-get"
            end

          end
        end
      end
    end
  end
end
