module VagrantBindfs
  module Capabilities
    module Darwin
      module Checks
        class << self

          def bindfs_check_user(machine, user)
            (
              user.nil? || \
              machine.communicate.test("test -n \"$(dscacheutil -q user -a name #{user.shellescape})\"")
            )
          end

          def bindfs_check_group(machine, group)
            (
              group.nil? || \
              machine.communicate.test("test -n \"$(dscacheutil -q group -a name #{group.shellescape})\"")
            )
          end

        end
      end
    end
  end
end
