# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      autoload :All,    'vagrant-bindfs/vagrant/capabilities/all'

      autoload :Darwin, 'vagrant-bindfs/vagrant/capabilities/darwin'
      autoload :Linux,  'vagrant-bindfs/vagrant/capabilities/linux'

      autoload :Debian, 'vagrant-bindfs/vagrant/capabilities/debian'
      autoload :Ubuntu, 'vagrant-bindfs/vagrant/capabilities/ubuntu'

      autoload :Gentoo, 'vagrant-bindfs/vagrant/capabilities/gentoo'

      autoload :RedHat, 'vagrant-bindfs/vagrant/capabilities/redhat'

      autoload :Suse,   'vagrant-bindfs/vagrant/capabilities/suse'

      class << self
        def included(base)
          declare_capabilities_for_system_checks!(base)
          declare_capabilities_for_package_manager!(base)
          declare_capabilities_for_fuse!(base)
          declare_capabilities_for_bindfs!(base)
        end

        def declare_capabilities_for_system_checks!(base)
          declare_capability!(base, 'bindfs_exists_user', {
            darwin: Capabilities::Darwin::SystemChecks,
            linux:  Capabilities::Linux::SystemChecks,
          })
          
          declare_capability!(base, 'bindfs_exists_group', {
            darwin: Capabilities::Darwin::SystemChecks,
            linux:  Capabilities::Linux::SystemChecks,
          })

          declare_capability!(base, 'bindfs_exists_directory', {
            darwin: Capabilities::All::SystemChecks,
            linux:  Capabilities::All::SystemChecks,
          })

          declare_capability!(base, 'bindfs_exists_mount', {
            darwin: Capabilities::All::SystemChecks,
            linux:  Capabilities::All::SystemChecks,
          })
        end

        def declare_capabilities_for_package_manager!(base)
          declare_capability!(base, 'bindfs_package_manager_name', {
            darwin: Capabilities::Darwin::PackageManager,
            debian: Capabilities::Debian::PackageManager,
            gentoo: Capabilities::Gentoo::PackageManager,
            redhat: Capabilities::RedHat::PackageManager,
            suse:   Capabilities::Suse::PackageManager,
          })

          declare_capability!(base, 'bindfs_package_manager_installed', {
            darwin: Capabilities::All::PackageManager,
            linux:  Capabilities::All::PackageManager,
          })

          declare_capability!(base, 'bindfs_package_manager_install', {
            darwin: Capabilities::Darwin::PackageManager,
            linux:  Capabilities::Linux::PackageManager,
          })
          
          declare_capability!(base, 'bindfs_package_manager_update', {
            darwin: Capabilities::Darwin::PackageManager,
            debian: Capabilities::Debian::PackageManager,
            gentoo: Capabilities::Gentoo::PackageManager,
            redhat: Capabilities::RedHat::PackageManager,
            suse:   Capabilities::Suse::PackageManager,
          })
        end

        def declare_capabilities_for_fuse!(base)
          declare_capability!(base, 'bindfs_fuse_installed', {
            darwin: Capabilities::Darwin::Fuse,
            linux:  Capabilities::Linux::Fuse,
          })

          declare_capability!(base, 'bindfs_fuse_install', {
            darwin: Capabilities::Darwin::Fuse,
            debian: Capabilities::Debian::Fuse,
            gentoo: Capabilities::Gentoo::Fuse,
            redhat: Capabilities::RedHat::Fuse,
            suse:   Capabilities::Suse::Fuse,
          })
          
          declare_capability!(base, 'bindfs_fuse_loaded', {
            darwin: Capabilities::Darwin::Fuse,
            linux:  Capabilities::Linux::Fuse,
            ubuntu: Capabilities::Ubuntu::Fuse,
          })

          declare_capability!(base, 'bindfs_fuse_load', {
            darwin: Capabilities::Darwin::Fuse,
            linux:  Capabilities::Linux::Fuse,
            ubuntu: Capabilities::Ubuntu::Fuse,
          })
        end

        def declare_capabilities_for_bindfs!(base)
          declare_capability!(base, 'bindfs_bindfs_full_path', {
            darwin: Capabilities::All::Bindfs,
            linux:  Capabilities::All::Bindfs,
          })
          
          declare_capability!(base, 'bindfs_bindfs_installed', {
            darwin: Capabilities::All::Bindfs,
            linux:  Capabilities::All::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_version', {
            darwin: Capabilities::All::Bindfs,
            linux:  Capabilities::All::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_search', {
            darwin: Capabilities::Darwin::Bindfs,
            debian: Capabilities::Debian::Bindfs,
            gentoo: Capabilities::Gentoo::Bindfs,
            redhat: Capabilities::RedHat::Bindfs,
            suse:   Capabilities::Suse::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_install', {
            darwin: Capabilities::Darwin::Bindfs,
            debian: Capabilities::Debian::Bindfs,
            gentoo: Capabilities::Gentoo::Bindfs,
            redhat: Capabilities::RedHat::Bindfs,
            suse:   Capabilities::Suse::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_search_version', {
            darwin: Capabilities::Darwin::Bindfs,
            debian: Capabilities::Debian::Bindfs,
            gentoo: Capabilities::Gentoo::Bindfs,
            redhat: Capabilities::RedHat::Bindfs,
            suse:   Capabilities::Suse::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_install_version', {
            darwin: Capabilities::Darwin::Bindfs,
            debian: Capabilities::Debian::Bindfs,
            gentoo: Capabilities::Gentoo::Bindfs,
            redhat: Capabilities::RedHat::Bindfs,
            suse:   Capabilities::Suse::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_install_compilation_requirements', {
            darwin: Capabilities::Darwin::Bindfs,
            debian: Capabilities::Debian::Bindfs,
            gentoo: Capabilities::Gentoo::Bindfs,
            redhat: Capabilities::RedHat::Bindfs,
            suse:   Capabilities::Suse::Bindfs,
          })

          declare_capability!(base, 'bindfs_bindfs_install_from_source', {
            darwin: Capabilities::All::Bindfs,
            linux:  Capabilities::All::Bindfs,
          })
        end
        
        private
        
        def declare_capability!(base, cap_name, oses = {})
          oses.each do |os_name, _module|
            base.guest_capability(os_name, cap_name) { _module }
          end
        end
      end
    end
  end
end
