module VagrantPlugins
  module Bindfs
    module Cap
      module SUSE
        module BindfsInstall

          def self.bindfs_install(machine)
            machine.communicate.tap do |comm|
              comm.sudo("zypper -n install bindfs")
            end
          end

        end # BindfsInstall
      end # Debian
    end # Cap
  end # Bindfs
end # VagrantPlugins
