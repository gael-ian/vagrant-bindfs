# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Linux
        module PackageManager
          class << self
            def bindfs_package_manager_install(_machine)
              raise VagrantBindfs::Vagrant::Error, :package_manager_missing
            end
          end
        end
      end
    end
  end
end
