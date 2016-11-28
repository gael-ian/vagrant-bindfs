module VagrantBindfs
  module Vagrant
    module Actions
      module Concerns
        module Log

          def logger
            env[:ui]
          end

          def debug(message)
            logger.detail(message) if config.debug
          end

          def detail(message)
            logger.detail(message)
          end

          def info(message)
            logger.info message
          end

          def warn(message)
            logger.warn message
          end

          def error(message)
            logger.error message
          end

        end
      end
    end
  end
end
