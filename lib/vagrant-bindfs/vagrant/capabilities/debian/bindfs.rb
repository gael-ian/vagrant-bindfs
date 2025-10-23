# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module Bindfs # :nodoc:
          class << self
            def bindfs_bindfs_search(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.test('[[ $(sudo apt-cache search bindfs | egrep "^bindfs - " | wc -l) != 0 ]]')
            end

            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('apt-get install -y bindfs')
            end

            # rubocop:disable Layout/LineLength, Naming/PredicateMethod
            def bindfs_bindfs_search_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                # Ensure aptitude is installed as Ubuntu removed it
                comm.sudo('apt-get install aptitude')
                comm.sudo("aptitude versions bindfs | sed -n '/p/,${p}' | sed 's/\s+/ /g' | cut -d' ' -f2") do |_, output|
                  package_version = output.strip
                  next false if package_version.empty? || package_version.match(/^#{version}/).nil?

                  "bindfs-#{package_version}"
                end
              end
              false
            end
            # rubocop:enable Layout/LineLength, Naming/PredicateMethod

            def bindfs_bindfs_install_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              package_version = machine.guest.capability(:bindfs_bindfs_search_version, version)
              machine.communicate.sudo("apt-get install -y bindfs=#{package_version.shellescape}")
            end

            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('apt-get install -y build-essential pkg-config wget tar libfuse3-dev')
            end
          end
        end
      end
    end
  end
end
