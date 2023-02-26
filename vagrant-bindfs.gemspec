# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-bindfs/version'

Gem::Specification.new do |spec|
  spec.name         = 'vagrant-bindfs'
  spec.version      = VagrantBindfs::VERSION
  spec.licenses     = ['MIT']
  spec.authors      = ['Gaël-Ian Havard', 'Igor Serebryany', 'Thomas Boerger']
  spec.email        = ['gaelian.havard@gmail.com', 'igor.serebryany@airbnb.com']

  spec.summary      = 'A Vagrant plugin to automate bindfs mount in the VM'
  spec.description  = <<-DESC.gsub(/\s+/, ' ')
    A Vagrant plugin to automate bindfs mount in the VM.
    Allows you to change owner, group and permissions on files and work around NFS share permissions issues.
  DESC
  spec.homepage = 'https://github.com/gael-ian/vagrant-bindfs'

  raise 'RubyGems 2.0 or newer is required.' unless spec.respond_to?(:metadata)

  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'rubygems_mfa_required' => 'true',

    'bug_tracker_uri' => 'https://github.com/gael-ian/vagrant-bindfs/issues',
    'changelog_uri' => 'https://github.com/gael-ian/vagrant-bindfs/blob/main/CHANGELOG.md',
    'homepage_uri' => 'https://github.com/gael-ian/vagrant-bindfs',
    'source_code_uri' => 'https://github.com/gael-ian/vagrant-bindfs',
    'funding_uri' => 'https://opencollective.com/notus-sh'
  }

  spec.require_paths = ['lib']

  excluded_dirs = %r{^(.github|spec)/}
  excluded_files = %w[.gitignore .rspec .rubocop.yml Gemfile Gemfile.lock Rakefile]
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(excluded_dirs) || excluded_files.include?(f)
  end

  spec.required_ruby_version = ">= 2.7", "< 3.2"
end
