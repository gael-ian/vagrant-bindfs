# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian # :nodoc:
        autoload :PackageManager, 'vagrant-bindfs/vagrant/capabilities/debian/package_manager'
        autoload :Fuse, 'vagrant-bindfs/vagrant/capabilities/debian/fuse'
        autoload :Bindfs, 'vagrant-bindfs/vagrant/capabilities/debian/bindfs'
      end
    end
  end
end
