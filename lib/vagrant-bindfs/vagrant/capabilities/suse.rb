# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Suse
        autoload :PackageManager, 'vagrant-bindfs/vagrant/capabilities/suse/package_manager'
        autoload :Fuse,           'vagrant-bindfs/vagrant/capabilities/suse/fuse'
        autoload :Bindfs,         'vagrant-bindfs/vagrant/capabilities/suse/bindfs'
      end
    end
  end
end
