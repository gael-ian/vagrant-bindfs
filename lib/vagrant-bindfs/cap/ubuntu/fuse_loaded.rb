module VagrantBindfs
  module Cap
    module Ubuntu
      module FuseLoaded
        class << self

          def fuse_loaded(machine)
            # Ubuntu 6.10 and after automatically load fuse.
            # Just check if it is installed
            machine.communicate.test("test -e /dev/fuse")
          end

        end
      end
    end
  end
end
