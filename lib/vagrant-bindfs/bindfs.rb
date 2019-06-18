# frozen_string_literal: true

module VagrantBindfs
  module Bindfs
    SOURCE_VERSION  = '1.14.0'
    SOURCE_URLS     = [
      'https://bindfs.org/downloads/%<basename>s.tar.gz',
      'https://bindfs.dy.fi/downloads/%<basename>s.tar.gz'
    ].freeze

    autoload :Command,    'vagrant-bindfs/bindfs/command'
    autoload :Folder,     'vagrant-bindfs/bindfs/folder'
    autoload :OptionSet,  'vagrant-bindfs/bindfs/option_set'
    autoload :Validators, 'vagrant-bindfs/bindfs/validators'
  end
end
