# frozen_string_literal: true

module VagrantBindfs
  module Bindfs
    SOURCE_VERSION  = '1.13.7'
    SOURCE_URLS     = [
      'http://bindfs.org/downloads/bindfs-%<bindfs_version>.tar.gz',
      'http://bindfs.dnsalias.net/downloads/bindfs-%<bindfs_version>.tar.gz'
    ].freeze

    autoload :Command,    'vagrant-bindfs/bindfs/command'
    autoload :Folder,     'vagrant-bindfs/bindfs/folder'
    autoload :OptionSet,  'vagrant-bindfs/bindfs/option_set'
    autoload :Validators, 'vagrant-bindfs/bindfs/validators'
  end
end
