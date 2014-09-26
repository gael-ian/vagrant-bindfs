module VagrantPlugins
  module Bindfs
    module Cap
      module Debian
        module BindfsInstall

          def self.bindfs_install(machine)
            machine.communicate.tap do |comm|
              comm.sudo("apt-get update")
              comm.sudo("apt-get install -y bindfs")
            end
          end

        end
      end
    end
  end
end
