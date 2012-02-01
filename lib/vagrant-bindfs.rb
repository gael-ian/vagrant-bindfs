require 'vagrant'
require 'vagrant-bindfs/error'
require 'vagrant-bindfs/config'
require 'vagrant-bindfs/middleware'

# Register Bindfs config
Vagrant.config_keys.register(:bindfs) { VagrantBindfs::Config }

# Insert Bindfs before the NFS middleware in the ":start" and ":up" Action stack
Vagrant.actions[:start].insert Vagrant::Action::VM::NFS, VagrantBindfs::Middleware
Vagrant.actions[:up].insert Vagrant::Action::VM::NFS, VagrantBindfs::Middleware

# Add custom translations to the load path
I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)