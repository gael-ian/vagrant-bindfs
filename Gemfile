source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", git: "https://github.com/mitchellh/vagrant.git"
end

group :plugins do
  # As documented by vagrant we need to include this vagrant plugin
  # just in the plugins group to get it loaded at the correct
  # position while developing it.
  gem "vagrant-bindfs", path: "."

  # Here you can include other plugins if you need them in order
  # to maybe test other providers like vmware or libvirt.
  #gem "vagrant-libvirt"
end
