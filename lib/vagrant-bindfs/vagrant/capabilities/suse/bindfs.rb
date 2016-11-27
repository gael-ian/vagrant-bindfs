module VagrantBindfs
  module Vagrant
    module Capabilities
      module Suse
        module Bindfs
          class << self

            def bindfs_bindfs_install(machine)
              machine.communicate.sudo("zypper -n install bindfs")
            end

          end
        end
      end
    end
  end
end
