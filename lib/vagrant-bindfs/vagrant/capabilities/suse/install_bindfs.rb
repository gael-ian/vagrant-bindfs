module VagrantBindfs
  module Vagrant
    module Cap
      module Suse
        module InstallBindfs
          class << self

            def install_bindfs(machine)
              machine.communicate.sudo("zypper -n install bindfs")
            end

          end
        end
      end
    end
  end
end
