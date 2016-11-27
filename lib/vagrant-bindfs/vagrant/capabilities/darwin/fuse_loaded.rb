module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin
        module FuseLoaded
          class << self

            def fuse_loaded(machine)
              # OSXFuse is automatically loaded.
              # Just check if it is installed
              machine.communicate.test("test -d /Library/Frameworks/OSXFUSE.framework/")
            end

          end
        end
      end
    end
  end
end
