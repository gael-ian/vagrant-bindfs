module VagrantBindfs
  module Vagrant
    module Capabilities

      autoload :All,    "vagrant-bindfs/vagrant/capabilities/all"

      autoload :Darwin, "vagrant-bindfs/vagrant/capabilities/darwin"
      autoload :Linux,  "vagrant-bindfs/vagrant/capabilities/linux"

      autoload :Debian, "vagrant-bindfs/vagrant/capabilities/debian"
      autoload :Ubuntu, "vagrant-bindfs/vagrant/capabilities/ubuntu"

      autoload :RedHat, "vagrant-bindfs/vagrant/capabilities/redhat"

      autoload :Suse,   "vagrant-bindfs/vagrant/capabilities/suse"


      class << self

        def included(base)
          declare_capabilities_for_system_checks!(base)
          declare_capabilities_for_package_manager!(base)
          declare_capabilities_for_fuse!(base)
          declare_capabilities_for_bindfs!(base)
        end

        def declare_capabilities_for_system_checks!(base)
          base.guest_capability("darwin", "bindfs_exists_user") { Capabilities::Darwin::SystemChecks }
          base.guest_capability("linux",  "bindfs_exists_user") { Capabilities::Linux::SystemChecks }

          base.guest_capability("darwin", "bindfs_exists_group") { Capabilities::Darwin::SystemChecks }
          base.guest_capability("linux",  "bindfs_exists_group") { Capabilities::Linux::SystemChecks }

          base.guest_capability("darwin", "bindfs_exists_directory") { Capabilities::All::SystemChecks }
          base.guest_capability("linux",  "bindfs_exists_directory") { Capabilities::All::SystemChecks }

          base.guest_capability("darwin", "bindfs_exists_mount") { Capabilities::All::SystemChecks }
          base.guest_capability("linux",  "bindfs_exists_mount") { Capabilities::All::SystemChecks }
        end

        def declare_capabilities_for_package_manager!(base)
          base.guest_capability("darwin", "bindfs_package_manager_name") { Capabilities::Darwin::PackageManager }
          base.guest_capability("debian", "bindfs_package_manager_name") { Capabilities::Debian::PackageManager }
          base.guest_capability("redhat", "bindfs_package_manager_name") { Capabilities::RedHat::PackageManager }
          base.guest_capability("suse",   "bindfs_package_manager_name") { Capabilities::Suse::PackageManager }

          base.guest_capability("darwin", "bindfs_package_manager_installed") { Capabilities::All::PackageManager }
          base.guest_capability("linux",  "bindfs_package_manager_installed") { Capabilities::All::PackageManager }

          base.guest_capability("darwin", "bindfs_package_manager_install") { Capabilities::Darwin::PackageManager }
          base.guest_capability("linux",  "bindfs_package_manager_install") { Capabilities::Linux::PackageManager }

          base.guest_capability("darwin", "bindfs_package_manager_update") { Capabilities::Darwin::PackageManager }
          base.guest_capability("debian", "bindfs_package_manager_update") { Capabilities::Debian::PackageManager }
          base.guest_capability("redhat", "bindfs_package_manager_update") { Capabilities::RedHat::PackageManager }
          base.guest_capability("suse",   "bindfs_package_manager_update") { Capabilities::Suse::PackageManager }
        end

        def declare_capabilities_for_fuse!(base)
          base.guest_capability("darwin", "bindfs_fuse_installed") { Capabilities::Darwin::Fuse }
          base.guest_capability("linux",  "bindfs_fuse_installed") { Capabilities::Linux::Fuse }

          base.guest_capability("darwin", "bindfs_fuse_install") { Capabilities::Darwin::Fuse }
          base.guest_capability("debian", "bindfs_fuse_install") { Capabilities::Debian::Fuse }
          base.guest_capability("redhat", "bindfs_fuse_install") { Capabilities::RedHat::Fuse }
          base.guest_capability("suse",   "bindfs_fuse_install") { Capabilities::Suse::Fuse }

          base.guest_capability("darwin", "bindfs_fuse_loaded") { Capabilities::Darwin::Fuse }
          base.guest_capability("linux",  "bindfs_fuse_loaded") { Capabilities::Linux::Fuse }
          base.guest_capability("ubuntu", "bindfs_fuse_loaded") { Capabilities::Ubuntu::Fuse }

          base.guest_capability("darwin", "bindfs_fuse_load") { Capabilities::Darwin::Fuse }
          base.guest_capability("linux",  "bindfs_fuse_load") { Capabilities::Linux::Fuse }
          base.guest_capability("ubuntu", "bindfs_fuse_load") { Capabilities::Ubuntu::Fuse }
        end

        def declare_capabilities_for_bindfs!(base)
          base.guest_capability("darwin", "bindfs_bindfs_installed") { Capabilities::All::Bindfs }
          base.guest_capability("linux",  "bindfs_bindfs_installed") { Capabilities::All::Bindfs }

          base.guest_capability("darwin", "bindfs_bindfs_version") { Capabilities::All::Bindfs }
          base.guest_capability("linux",  "bindfs_bindfs_version") { Capabilities::All::Bindfs }

          base.guest_capability("darwin", "bindfs_bindfs_install") { Capabilities::Darwin::Bindfs }
          base.guest_capability("debian", "bindfs_bindfs_install") { Capabilities::Debian::Bindfs }
          base.guest_capability("redhat", "bindfs_bindfs_install") { Capabilities::RedHat::Bindfs }
          base.guest_capability("suse",   "bindfs_bindfs_install") { Capabilities::Suse::Bindfs }

          base.guest_capability("darwin", "bindfs_bindfs_search_version") { Capabilities::Darwin::Bindfs }
          base.guest_capability("debian", "bindfs_bindfs_search_version") { Capabilities::Debian::Bindfs }
          base.guest_capability("redhat", "bindfs_bindfs_search_version") { Capabilities::RedHat::Bindfs }
          base.guest_capability("suse",   "bindfs_bindfs_search_version") { Capabilities::Suse::Bindfs }

          base.guest_capability("darwin", "bindfs_bindfs_install_version") { Capabilities::Darwin::Bindfs }
          base.guest_capability("debian", "bindfs_bindfs_install_version") { Capabilities::Debian::Bindfs }
          base.guest_capability("redhat", "bindfs_bindfs_install_version") { Capabilities::RedHat::Bindfs }
          base.guest_capability("suse",   "bindfs_bindfs_install_version") { Capabilities::Suse::Bindfs }

          base.guest_capability("darwin", "bindfs_bindfs_install_compilation_requirements") { Capabilities::Darwin::Bindfs }
          base.guest_capability("debian", "bindfs_bindfs_install_compilation_requirements") { Capabilities::Debian::Bindfs }
          base.guest_capability("redhat", "bindfs_bindfs_install_compilation_requirements") { Capabilities::RedHat::Bindfs }
          base.guest_capability("suse",   "bindfs_bindfs_install_compilation_requirements") { Capabilities::Suse::Bindfs }

          base.guest_capability("darwin", "bindfs_bindfs_install_from_source") { Capabilities::All::Bindfs }
          base.guest_capability("linux",  "bindfs_bindfs_install_from_source") { Capabilities::All::Bindfs }
        end

      end
      
    end
  end
end
