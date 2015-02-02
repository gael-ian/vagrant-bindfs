module VagrantPlugins
  module Bindfs
    module Cap
      module Linux
        module FuseLoaded

          def self.fuse_loaded(machine)
            machine.communicate.test("lsmod | grep -q fuse")
          end

        end
      end
    end
  end
end
