begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant bindfs plugin must be run within Vagrant"
end

require "pathname"

module VagrantBindfs

  autoload :Plugin,       "vagrant-bindfs/plugin"
  autoload :Config,       "vagrant-bindfs/config"
  autoload :Capabilities, "vagrant-bindfs/capabilities"
  autoload :Action,       "vagrant-bindfs/action"
  autoload :Error,        "vagrant-bindfs/errors"

  autoload :Command,      "vagrant-bindfs/command"

    
  def self.source_root
    @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
  end

  I18n.load_path << File.expand_path("locales/en.yml", source_root)
  I18n.reload!

end

require "vagrant-bindfs/plugin"
