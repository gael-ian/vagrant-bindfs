module VagrantPlugins
  module Bindfs
    module Cap
      module Linux
        module EnableFuse

          def self.enable_fuse(machine)
            machine.communicate.sudo("/sbin/modprobe fuse")
          end

        end
      end
    end
  end
end
