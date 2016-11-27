module VagrantBindfs
  module Vagrant
    module Capabilities
      module RedHat
        module Fuse
          class << self

            def bindfs_fuse_install(machine)
              machine.communicate.sudo("yum -y install fuse fuse-devel")
            end

          end
        end
      end
    end
  end
end
