# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin
        module SystemChecks
          class << self
            def bindfs_exists_user(machine, user)
              (
                user.nil? || \
                machine.communicate.test("test -n \"$(dscacheutil -q user -a name #{user.shellescape})\"")
              )
            end

            def bindfs_exists_group(machine, group)
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
end
