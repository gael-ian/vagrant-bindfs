begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant bindfs plugin must be run within Vagrant"
end

require "vagrant-bindfs/plugin"
require "vagrant-bindfs/errors"

require "pathname"

module VagrantPlugins
  module Bindfs
    # Returns the path to the source of this plugin
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    I18n.load_path << File.expand_path("locales/en.yml", source_root)
    I18n.reload!
  end
end
