# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Ubuntu
        module Fuse
          class << self
            # Ubuntu 6.10 and after automatically load fuse.
            # Just check if it is installed
            def bindfs_fuse_loaded(machine)
              machine.guest.capability(:bindfs_fuse_installed)
            end

            def bindfs_fuse_load(machine)
              machine.guest.capability(:bindfs_fuse_installed)
            end
          end
        end
      end
    end
  end
end
