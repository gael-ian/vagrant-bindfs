module VagrantPlugins
  module Bindfs
    class Error < Vagrant::Errors::VagrantError
      error_namespace("vagrant.config.bindfs.errors")
    end
  end
end
