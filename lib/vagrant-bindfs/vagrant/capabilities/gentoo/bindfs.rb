# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Gentoo
        module Bindfs # :nodoc:
          class << self
            def bindfs_bindfs_search(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                ensure_equery_is_installed(comm)
                return comm.test("equery -q list -po #{bindfs_package_name}")
              end
            end

            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                allow_bindfs_installation(comm)
                comm.sudo("emerge #{bindfs_package_name}")
              end
            end

            def bindfs_bindfs_search_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                ensure_equery_is_installed(comm)
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
              machine.communicate.tap do |comm|
                allow_bindfs_installation(comm)
                comm.sudo("emerge =#{bindfs_package_name}-#{package_version.shellescape}")
              end
            end

            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('emerge wget tar')
            end

            private

            def bindfs_package_name
              'sys-fs/bindfs'
            end

            def allow_bindfs_installation(communicator)
              communicator.sudo <<-SHELL
                arch=$(equery -q list -po -F '$keywords' #{bindfs_package_name})
                keywords=$(echo $arch | tr ' ' "\n" | sort | uniq | tr "\n" ' ')
                echo "#{bindfs_package_name} $keywords" > /etc/portage/package.accept_keywords/bindfs
              SHELL
            end

            def ensure_equery_is_installed(communicator)
              return if communicator.test("equery --help")

              # Let the whole system falls back on distribution defaults for supported Python versions.
              communicator.sudo("sed -i '/^PYTHON_TARGETS=.*$/d' /etc/portage/make.conf")
              communicator.sudo('emerge app-portage/gentoolkit')
            end
          end
        end
      end
    end
  end
end
