# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module All
        module SystemChecks # :nodoc:
          class << self
            def bindfs_exists_directory(machine, directory)
              machine.communicate.test("test -d #{directory.shellescape}")
            end

            def bindfs_exists_mount(machine, directory)
              machine.communicate.test("mount | grep '^bindfs' | grep #{directory.shellescape}")
            end
          end
        end
      end
    end
  end
end
