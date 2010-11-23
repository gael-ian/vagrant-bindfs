require 'vagrant'
require 'vagrant-bindfs/config'
require 'vagrant-bindfs/middleware'

# Insert Bindfs at the end of the "up" Action stack
Vagrant::Action[:start].insert Vagrant::Action::VM::NFS, VagrantBindfs::Middleware

# Add our custom translations to the load path
I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)