module VagrantBindfs
  module Vagrant
    module Capabilities
      module All
        module BindfsInstalled
          class << self

            def bindfs_installed(machine)
              machine.communicate.test("bindfs --help")
            end

          end
        end
      end
    end
  end
end
