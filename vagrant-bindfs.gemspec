# -*- encoding: utf-8 -*-
require File.expand_path("../lib/vagrant-bindfs/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "vagrant-bindfs"
  s.version     = VagrantBindfs::VERSION
  s.authors     = ["Folken Laëneck"]
  s.email       = ["folken.laeneck@gmail.com"]
  s.homepage    = "https://github.com/folken-laeneck/vagrant-bindfs"
  
  s.summary     = "A Vagrant plugin to automate bindfs mount in the VM"
  s.description = "A Vagrant plugin to automate bindfs mount in the VM. This allow you to change owner, group and permissions on files and, for example, work around NFS share permissions issues."

  s.files = Dir['lib/**/*.rb'] + Dir['locales/*.yml'] + ['README.md', 'LICENSE.txt']
  
  s.add_dependency "vagrant", "~> 1.0.5"
  
end
