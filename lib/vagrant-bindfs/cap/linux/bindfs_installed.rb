module VagrantPlugins
  module Bindfs
    module Cap
      module Linux
        module BindfsInstalled

          def self.bindfs_installed(machine)
            machine.communicate.test("bindfs --help")
          end

          def self.loaded_fuse?(machine)
            machine.communicate.test("lsmod | grep -q fuse")
          end

          def self.modprobe_fuse(machine)
            machine.communicate.sudo("/sbin/modprobe fuse")
          end

        end
      end
    end
  end
end
