module VagrantPlugins
  module Bindfs
    module Cap
      module Fedora
        module InstallBindfs

          def self.install_bindfs(machine)
            machine.communicate.tap do |comm|
              comm.sudo('yum -y install bindfs')
            end
          end

        end
      end
    end
  end
end
