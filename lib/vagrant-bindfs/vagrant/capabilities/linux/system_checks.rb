# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module Linux
        module SystemChecks
          class << self
            def bindfs_exists_user(machine, user)
              (
                user.nil? || \
                machine.communicate.test("getent passwd #{user.to_s.shellescape}")
              )
            end

            def bindfs_exists_group(machine, group)
              (
                group.nil? || \
                machine.communicate.test("getent group #{group.to_s.shellescape}")
              )
            end
          end
        end
      end
    end
  end
end
