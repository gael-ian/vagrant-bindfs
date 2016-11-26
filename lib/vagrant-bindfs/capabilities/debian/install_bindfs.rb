module VagrantBindfs
  module Capabilities
    module Debian
      module InstallBindfs
        class << self

          def install_bindfs(machine)
            machine.communicate.sudo("apt-get update && apt-get install -y bindfs")
          end

        end
      end
    end
  end
end
