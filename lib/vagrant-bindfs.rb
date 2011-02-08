require 'vagrant'
require 'vagrant-bindfs/config'
require 'vagrant-bindfs/middleware'

# Insert Bindfs before the NFS middleware in the ":start" and ":up" Action stack
Vagrant::Action[:start].insert Vagrant::Action::VM::NFS, VagrantBindfs::Middleware
Vagrant::Action[:up].insert Vagrant::Action::VM::NFS, VagrantBindfs::Middleware

# Add custom translations to the load path
I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)