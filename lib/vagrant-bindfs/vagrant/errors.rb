module VagrantBindfs
  module Vagrant
    class Error < ::Vagrant::Errors::VagrantError
      error_namespace("vagrant-bindfs.errors")
    end

    class ConfigError < Error
      error_namespace("vagrant-bindfs.errors.config")
    end
  end
end
