module VagrantBindfs
  module Vagrant
    module Capabilities
      module Linux
        module FuseLoaded
          class << self

            def fuse_loaded(machine)
              machine.communicate.test("lsmod | grep -q fuse")
            end

          end
        end
      end
    end
  end
end
