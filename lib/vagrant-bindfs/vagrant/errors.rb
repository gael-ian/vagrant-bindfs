module VagrantBindfs
  module Vagrant
    class Error < ::Vagrant::Errors::VagrantError
      error_namespace("vagrant.config.bindfs.errors")
    end
  end
end
