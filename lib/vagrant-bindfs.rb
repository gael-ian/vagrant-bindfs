# frozen_string_literal: true

begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant bindfs plugin must be run within Vagrant'
end

module VagrantBindfs
  autoload :Vagrant,      'vagrant-bindfs/vagrant'
  autoload :Bindfs,       'vagrant-bindfs/bindfs'
end

I18n.load_path << File.expand_path('../locales/en.yml', __dir__)
I18n.reload!

require 'vagrant-bindfs/vagrant/plugin'
