# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin
        module Bindfs # :nodoc:
          class << self
            # Homebrew only use its own github repositories
            # rubocop:disable Naming/PredicateMethod
            def bindfs_bindfs_search(_machine)
              true
            end
            # rubocop:enable Naming/PredicateMethod

            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.execute('brew install homebrew/fuse/bindfs')
            end

            # Homebrew does not provide any method to install
            # an older version of a formula
            # rubocop:disable Naming/PredicateMethod
            def bindfs_bindfs_search_version(_machine, _version)
              false
            end
            # rubocop:enable Naming/PredicateMethod

            def bindfs_bindfs_install_version(machine)
              # Pass
            end

            # Homebrew requires the development tools to be installed
            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.execute('brew install autoconf automake libtool pkg-config wget')
            end
          end
        end
      end
    end
  end
end
