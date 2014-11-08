module VagrantPlugins
  module Bindfs
    module Cap
      module Fedora
        module BindfsInstall

          def self.bindfs_install(machine)
            machine.communicate.tap do |comm|
              comm.sudo('yum -y install bindfs')
            end
          end

        end
      end
    end
  end
end
