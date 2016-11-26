module VagrantBindfs
  module Cap
    module Linux
      module Checks
        class << self

          def bindfs_check_user(machine, user)
            (user.nil? || machine.communicate.test("getent passwd #{user.shellescape}"))
          end

          def bindfs_check_group(machine, group)
            (group.nil? || machine.communicate.test("getent group #{group.shellescape}"))
          end

        end
      end
    end
  end
end
