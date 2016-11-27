module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin
        module PackageManager
          class << self

            def bindfs_package_manager_name(machine)
              "brew"
            end

            def bindfs_package_manager_install(machine)
              machine.communicate.execute("/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"")
            end

          end
        end
      end
    end
  end
end
