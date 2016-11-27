module VagrantBindfs
  module Vagrant
    module Capabilities
      module Suse
        module Fuse
          class << self

            def bindfs_fuse_install(machine)
              machine.communicate.sudo("zypper -n install fuse")
            end

          end
        end
      end
    end
  end
end
