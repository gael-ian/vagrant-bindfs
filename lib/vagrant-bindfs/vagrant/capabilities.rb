# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      autoload :All,    'vagrant-bindfs/vagrant/capabilities/all'

      autoload :Darwin, 'vagrant-bindfs/vagrant/capabilities/darwin'
      autoload :Linux,  'vagrant-bindfs/vagrant/capabilities/linux'

      autoload :Debian, 'vagrant-bindfs/vagrant/capabilities/debian'
      autoload :Ubuntu, 'vagrant-bindfs/vagrant/capabilities/ubuntu'

      autoload :Gentoo, 'vagrant-bindfs/vagrant/capabilities/gentoo'

      autoload :RedHat, 'vagrant-bindfs/vagrant/capabilities/redhat'

      autoload :Suse,   'vagrant-bindfs/vagrant/capabilities/suse'

      class << self
        def included(base)
          capabilities = JSON.parse(File.read(File.expand_path('capabilities.json', __dir__)))
          capabilities.each do |cap_name, oses|
            oses.each do |os_name, module_name|
              mod = module_by_name(module_name)
              base.guest_capability(os_name.to_s, cap_name.to_s) { mod }
            end
          end
        end

        def module_by_name(camel_cased_word)
          camel_cased_word.split('::').inject(self) { |constant, name| constant.const_get(name) }
        end
      end
    end
  end
end
