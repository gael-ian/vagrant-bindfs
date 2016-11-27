begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant bindfs plugin must be run within Vagrant"
end

require "pathname"

module VagrantBindfs

  autoload :Vagrant,      "vagrant-bindfs/vagrant"
  autoload :Bindfs,       "vagrant-bindfs/bindfs"


    
  def self.source_root
    @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
  end

  I18n.load_path << File.expand_path("locales/en.yml", source_root)
  I18n.reload!

end

require "vagrant-bindfs/vagrant/plugin"
