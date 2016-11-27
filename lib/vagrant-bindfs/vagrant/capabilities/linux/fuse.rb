module VagrantBindfs
  module Vagrant
    module Capabilities
      module Linux
        module Fuse
          class << self

            def bindfs_fuse_installed(machine)
              machine.communicate.test("test -e /dev/fuse")
            end

            def bindfs_fuse_loaded(machine)
              machine.communicate.test("lsmod | grep -q fuse")
            end

            def bindfs_fuse_load(machine)
              machine.communicate.sudo("/sbin/modprobe fuse")
            end

          end
        end
      end
    end
  end
end
