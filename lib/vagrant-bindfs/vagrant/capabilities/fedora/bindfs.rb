module VagrantBindfs
  module Vagrant
    module Capabilities
      module Fedora
        module Bindfs
          class << self

            def bindfs_bindfs_install(machine)
              machine.communicate.sudo('yum -y install bindfs')
            end

          end
        end
      end
    end
  end
end
