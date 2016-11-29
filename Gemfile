source "https://rubygems.org"

# Du to some changes in bundler, specifying dependencies with the `gemspec`
# keyword will trigger an error as `vagrant-bindfs` would then be declared
# twice, once here and once in the :plugins group.
# 
# To work around this issue, development dependencies should be added to
# the :development group below instead of in `.gemspec` file.
#
# gemspec

group :development do

  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", git: "https://github.com/mitchellh/vagrant.git"
  
  # Development dependencies
  gem "rake"
  gem "rspec",  "~> 3.5.0"
  gem "rubocop", require: false

end

group :plugins do
  # `vagrant-bindfs` (and other plugins that it may depends on) must be
  # included in this :plugins group to get loaded at the correct position
  # while developing.
  gem "vagrant-bindfs", path: "."
end
