module VagrantPlugins
  module Bindfs
    module Cap
      module Suse
        module InstallBindfs

          def self.install_bindfs(machine)
            machine.communicate.tap do |comm|
              comm.sudo("zypper -n install bindfs")
            end
          end

        end
      end
    end
  end
end
