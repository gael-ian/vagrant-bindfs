module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module Bindfs
          class << self

            def bindfs_bindfs_install(machine)
              machine.communicate.sudo("apt-get update && apt-get install -y bindfs")
            end

          end
        end
      end
    end
  end
end
