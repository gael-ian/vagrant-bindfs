module VagrantPlugins
  module Bindfs
    module Cap
      module All
        module Checks
          class << self
        
            def bindfs_check_mount(machine, directory)
              machine.communicate.test("mount | grep '^bindfs' | grep #{directory.shellescape}")
            end

          end
        end
      end
    end
  end
end
