# -*- encoding: utf-8 -*-
require File.expand_path("../lib/vagrant-bindfs/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "vagrant-bindfs"
  s.version     = VagrantBindfs::VERSION
  s.authors     = ["Folken Laëneck"]
  s.email       = ["folken.laeneck@gmail.com"]
  
  s.summary     = "A Vagrant plugin to automate bindfs mount in the VM"
  s.description = "A Vagrant plugin to automate bindfs mount in the VM"

  s.add_dependency "vagrant", "~> 0.6.0"

  # s.required_rubygems_version = ">= 1.3.6"

  s.files = Dir['lib/**/*.rb'] + Dir['locales/*.yml'] + ['README.md', 'LICENSE.txt']
  
end
