module VagrantBindfs
  module Cap
    module Linux
      module EnableFuse
        class << self

          def enable_fuse(machine)
            machine.communicate.sudo("/sbin/modprobe fuse")
          end

        end
      end
    end
  end
end
