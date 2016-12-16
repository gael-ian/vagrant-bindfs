# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module Suse
        module Bindfs
          class << self
            def bindfs_bindfs_search(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.test('zypper se -s bindfs')
            end

            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('zypper -n install bindfs')
            end

            def bindfs_bindfs_search_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                comm.sudo("zypper se -s bindfs | sed -n '/bindfs/,${p}' | cut -d'|' -f2,4 --output-delimiter='-'") do |_, output|
                  package_name = output.strip
                  return package_name if !package_name.empty? && !package_name.match(/^bindfs-#{version}/).nil?
                end
              end
              false
            end

            def bindfs_bindfs_install_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              package_name = machine.guest.capability(:bindfs_bindfs_search_version, version)
              machine.communicate.sudo("zypper -n in -f #{package_name.shellescape}")
            end

            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                comm.sudo('zypper -n install make automake gcc gcc-c++ kernel-devel wget tar fuse-devel')
              end
            end
          end
        end
      end
    end
  end
end
