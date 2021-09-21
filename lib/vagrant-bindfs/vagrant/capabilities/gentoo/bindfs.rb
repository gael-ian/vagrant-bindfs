# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Gentoo
        module Bindfs
          class << self
            def bindfs_bindfs_search(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                # Ensure equery is installed
                comm.sudo('emerge app-portage/gentoolkit')
                return comm.test("equery -q list -po #{bindfs_package_name}")
              end
            end

            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              allow_bindfs_installation(machine)
              machine.communicate.sudo("emerge #{bindfs_package_name}")
            end

            def bindfs_bindfs_search_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                # Ensure equery is installed
                comm.sudo('emerge app-portage/gentoolkit')
                comm.sudo("equery -q list -po -F '$fullversion' #{bindfs_package_name} || true") do |_, output|
                  output.strip.gsub(/\s+/, ' ').split.each do |package_version|
                    return package_version unless package_version.match(/^#{version}/).nil?
                  end
                end
              end
              false
            end

            def bindfs_bindfs_install_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              package_version = machine.guest.capability(:bindfs_bindfs_search_version, version)
              allow_bindfs_installation(machine)
              machine.communicate.sudo("emerge =#{bindfs_package_name}-#{package_version.shellescape}")
            end

            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('emerge wget tar')
            end

            private

            def bindfs_package_name
              'sys-fs/bindfs'
            end

            def allow_bindfs_installation(machine)
              machine.communicate.sudo <<-SHELL
                arch=$(equery -q list -po -F '$keywords' #{bindfs_package_name})
                keywords=$(echo $arch | tr ' ' "\n" | sort | uniq | tr "\n" ' ')
                echo "#{bindfs_package_name} $keywords" > /etc/portage/package.accept_keywords/bindfs
              SHELL
            end
          end
        end
      end
    end
  end
end
