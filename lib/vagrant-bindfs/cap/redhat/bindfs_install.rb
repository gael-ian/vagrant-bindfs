module VagrantPlugins
  module Bindfs
    module Cap
      module RedHat
        module BindfsInstall

          def self.bindfs_install(machine)
            machine.communicate.tap do |comm|
              if comm.test('grep "CentOS release 6" /etc/centos-release')
                comm.sudo('yum -y install fuse fuse-devel')
                comm.sudo('wget http://bindfs.org/downloads/bindfs-#{VagrantPlugins::Bindfs::SOURCE_VERSION}.tar.gz -O bindfs.tar.gz')
                comm.sudo('tar --overwrite -zxvf bindfs.tar.gz')
                comm.sudo('[ -d ./bindfs ] && cd bindfs && ./configure && make && make install')
                comm.sudo('ln -s /usr/local/bin/bindfs /usr/bin')
              else
                comm.sudo('yum -y install bindfs')
              end
            end
          end

        end # BindfsInstall
      end # RedHat
    end # Cap
  end # Bindfs
end # VagrantPlugins
