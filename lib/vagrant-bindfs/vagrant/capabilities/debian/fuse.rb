module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module Fuse
          class << self

            def bindfs_fuse_install(machine)
              machine.communicate.sudo("apt-get install -y fuse")
            end

          end
        end
      end
    end
  end
end
