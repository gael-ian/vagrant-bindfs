module VagrantPlugins
  module Bindfs
    module Cap
      module Linux
        module BindfsInstalled

          def self.bindfs_installed(machine)
            machine.communicate.test("bindfs --help")
          end

          def self.loaded_fuse?(machine)
            machine.communicate.test("lsmod | grep -q fuse || grep -q fuse /etc/modules")
          end

          def self.modprobe_fuse(machine)
            unless machine.communicate.test("grep -q fuse /etc/modules")
              machine.communicate.sudo("bash -c \"echo 'fuse' >> /etc/modules\"")
            end
            machine.communicate.sudo("/sbin/modprobe fuse")
          end

        end
      end
    end
  end
end
