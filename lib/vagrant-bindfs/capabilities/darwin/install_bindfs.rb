module VagrantBindfs
  module Capabilities
    module Darwin
      module InstallBindfs
        class << self

          def install_bindfs(machine)
            @machine = machine

            unless homebrew_installed?
              warn(I18n.t("vagrant.config.bindfs.homebrew_not_installed"))
              homebrew_install
            else
              execute("brew update")
            end

            unless osxfuse_installed?
              warn(I18n.t("vagrant.config.bindfs.osxfuse_not_installed"))
              osxfuse_install
            end

            execute("brew install homebrew/fuse/bindfs")
          end

          def warn(message)
            @machine.env.ui.warn(message)
          end

          def execute(command)
            @machine.communicate.execute(command)
          end

          def test(command)
            @machine.communicate.test(command)
          end

          protected

            def homebrew_installed?
              test("brew --help")
            end

            def homebrew_install
              execute("/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"")
            end

            def osxfuse_installed?
              test("[ -d /Library/Frameworks/OSXFUSE.framework/ ]")
            end

            def osxfuse_install
              execute("brew tap caskroom/cask && brew cask install osxfuse")
            end

        end
      end
    end
  end
end
