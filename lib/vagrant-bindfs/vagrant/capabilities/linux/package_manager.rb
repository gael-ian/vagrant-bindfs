module VagrantBindfs
  module Vagrant
    module Capabilities
      module Linux
        module PackageManager
          class << self

            def bindfs_package_manager_install(machine)
              raise VagrantBindfs::Vagrant::Error.new(:package_manager_missing)
            end

          end
        end
      end
    end
  end
end
