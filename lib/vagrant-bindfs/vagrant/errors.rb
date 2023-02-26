# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    class Error < ::Vagrant::Errors::VagrantError # :nodoc:
      error_namespace('vagrant-bindfs.errors')
    end

    class ConfigError < Error # :nodoc:
      error_namespace('vagrant_bindfs.errors.config')
    end
  end
end
