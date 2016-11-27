module VagrantBindfs
  module Vagrant
    module Capabilities
      module Darwin

        autoload :SystemChecks,   "vagrant-bindfs/vagrant/capabilities/darwin/system_checks"
        autoload :PackageManager, "vagrant-bindfs/vagrant/capabilities/darwin/package_manager"
        autoload :Fuse,           "vagrant-bindfs/vagrant/capabilities/darwin/fuse"
        autoload :Bindfs,         "vagrant-bindfs/vagrant/capabilities/darwin/bindfs"

      end
    end
  end
end
