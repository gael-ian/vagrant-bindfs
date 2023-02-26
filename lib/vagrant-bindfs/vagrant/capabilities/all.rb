# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module All # :nodoc:
        autoload :SystemChecks, 'vagrant-bindfs/vagrant/capabilities/all/system_checks'
        autoload :PackageManager, 'vagrant-bindfs/vagrant/capabilities/all/package_manager'
        autoload :Bindfs, 'vagrant-bindfs/vagrant/capabilities/all/bindfs'
      end
    end
  end
end
