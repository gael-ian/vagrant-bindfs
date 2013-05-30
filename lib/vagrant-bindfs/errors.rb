require "vagrant"

module VagrantPlugins
  module Bindfs
    class Error < Vagrant::Errors::VagrantError
      error_namespace("vagrant.guest.linux.bindfs.errors")
    end
  end
end
