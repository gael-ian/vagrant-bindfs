# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'vagrant-bindfs/version'

Gem::Specification.new do |s|
  s.name = 'vagrant-bindfs'
  s.version = VagrantBindfs::VERSION
  s.summary = 'A Vagrant plugin to automate bindfs mount in the VM'
  s.description = <<-DESC.gsub(/\s+/, ' ')
    A Vagrant plugin to automate bindfs mount in the VM.
    This allow you to change owner, group and permissions on files and, for example,
    work around NFS share permissions issues.
  DESC

  s.license = 'MIT'
  s.authors = ['Gaël-Ian Havard', 'Igor Serebryany', 'Thomas Boerger']
  s.email = ['gaelian.havard@gmail.com', 'igor.serebryany@airbnb.com']

  s.homepage = 'https://github.com/gael-ian/vagrant-bindfs'
  if s.respond_to?(:metadata=)
    s.metadata = {
      'allowed_push_host' => 'https://rubygems.org',
      'issue_tracker' => 'https://github.com/gael-ian/vagrant-bindfs/issues'
    }
  end

  s.files = Dir['{lib,locales}/**/*'] + ['README.md', 'Rakefile', 'MIT-LICENSE']
  s.test_files = Dir['{specs}/**/*'] + ['Vagrantfile']

  s.required_ruby_version = ">= 2.7", "< 3.2"
  s.required_rubygems_version = '>= 1.3.6'
end
