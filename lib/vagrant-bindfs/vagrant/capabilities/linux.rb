# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Linux
        autoload :SystemChecks,   'vagrant-bindfs/vagrant/capabilities/linux/system_checks'
        autoload :PackageManager, 'vagrant-bindfs/vagrant/capabilities/linux/package_manager'
        autoload :Fuse,           'vagrant-bindfs/vagrant/capabilities/linux/fuse'
      end
    end
  end
end
