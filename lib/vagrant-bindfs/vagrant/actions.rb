# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Actions
      autoload :Installer,  'vagrant-bindfs/vagrant/actions/installer'
      autoload :Mounter,    'vagrant-bindfs/vagrant/actions/mounter'

      autoload :Concerns,   'vagrant-bindfs/vagrant/actions/concerns'
    end
  end
end
