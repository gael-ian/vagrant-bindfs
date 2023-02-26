# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module Ubuntu # :nodoc:
        autoload :Fuse, 'vagrant-bindfs/vagrant/capabilities/ubuntu/fuse'
      end
    end
  end
end
