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

          def binded_folders(hook = nil)
            @binded_folders ||= begin
              config.binded_folders.reduce({}) do |binded, (id, folder)|
                binded[id] = folder if hook.nil? || folder.hook == hook
                binded
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
