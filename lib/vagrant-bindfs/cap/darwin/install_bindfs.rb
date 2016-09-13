module VagrantPlugins
  module Bindfs
    module Cap
      module Darwin
        module InstallBindfs

          def self.install_bindfs(machine)
            unless self.homebrew_installed?(machine)
              @env[:ui].warn(I18n.t("vagrant.config.bindfs.homebrew_not_installed"))
              self.install_homebrew(machine)
            end
            
            machine.communicate.tap do |comm|
              comm.sudo("brew tap homebrew-fuse")
              comm.sudo("brew update")
              comm.sudo("brew install bindfs")
            end
          end
          
          def self.homebrew_installed?(machine)
            machine.communicate.test("brew --help")
          end
          
          def self.install_homebrew(machine)
            machine.communicate.sudo <<-COMMAND
              /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            COMMAND
          end

        end
      end
    end
  end
end
