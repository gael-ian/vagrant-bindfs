# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module RedHat # :nodoc:
        autoload :PackageManager, 'vagrant-bindfs/vagrant/capabilities/redhat/package_manager'
        autoload :Fuse, 'vagrant-bindfs/vagrant/capabilities/redhat/fuse'
        autoload :Bindfs, 'vagrant-bindfs/vagrant/capabilities/redhat/bindfs'
      end
    end
  end
end
