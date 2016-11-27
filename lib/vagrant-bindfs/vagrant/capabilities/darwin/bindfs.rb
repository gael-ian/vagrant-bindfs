module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin
        module Bindfs
          class << self

            def bindfs_bindfs_install(machine)
              machine.communicate.execute("brew install homebrew/fuse/bindfs")
            end

          end
        end
      end
    end
  end
end
