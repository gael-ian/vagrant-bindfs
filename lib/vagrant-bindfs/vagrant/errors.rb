module VagrantBindfs
  module Vagrant
    class Error < ::Vagrant::Errors::VagrantError
      error_namespace("vagrant-bindfs.errors")
    end
  end
end
