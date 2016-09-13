module VagrantPlugins
  module Bindfs
    module Cap
      module All
        module EnableFuse

          def self.enable_fuse(machine)
            machine.communicate.sudo("/sbin/modprobe fuse")
          end

        end
      end
    end
  end
end
