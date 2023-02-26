# frozen_string_literal: true

module VagrantBindfs
  module Bindfs
    module Validators # :nodoc:
      autoload :Config, 'vagrant-bindfs/bindfs/validators/config'
      autoload :Runtime, 'vagrant-bindfs/bindfs/validators/runtime'
    end
  end
end
