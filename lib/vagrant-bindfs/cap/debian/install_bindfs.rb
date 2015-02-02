module VagrantPlugins
  module Bindfs
    module Cap
      module Debian
        module InstallBindfs

          def self.install_bindfs(machine)
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
