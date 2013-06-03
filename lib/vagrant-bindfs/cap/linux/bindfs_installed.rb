module VagrantPlugins
  module Bindfs
    module Cap
      module Linux
        module BindfsInstalled

          def self.bindfs_installed(machine)
            machine.communicate.test('bindfs --help')
          end

        end # BindfsInstalled
      end # Linux
    end # Cap
  end # Bindfs
end # module VagrantPlugins
