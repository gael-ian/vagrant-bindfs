# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Actions
      module Concerns
        module Machine
          def machine
            env[:machine]
          end

          def config
            machine.config.bindfs
          end

          def bound_folders(hook = nil)
            @bound_folders ||= begin
              config.bound_folders.each_with_object({}) do |(id, folder), bound|
                bound[id] = folder if hook.nil? || folder.hook == hook
                bound
              end
            end
          end

          def guest
            machine.guest
          end
        end
      end
    end
  end
end
