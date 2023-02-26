# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Actions
      module Concerns # :nodoc:
        autoload :Log, 'vagrant-bindfs/vagrant/actions/concerns/log'
        autoload :Machine, 'vagrant-bindfs/vagrant/actions/concerns/machine'
      end
    end
  end
end
