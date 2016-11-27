module VagrantPlugins
  module Vagrant
    module Capabilities
      module Linux
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
