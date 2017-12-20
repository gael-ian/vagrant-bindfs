# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Gentoo
        autoload :PackageManager, 'vagrant-bindfs/vagrant/capabilities/gentoo/package_manager'
        autoload :Fuse,           'vagrant-bindfs/vagrant/capabilities/gentoo/fuse'
        autoload :Bindfs,         'vagrant-bindfs/vagrant/capabilities/gentoo/bindfs'
      end
    end
  end
end
