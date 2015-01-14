module VagrantPlugins
  module Bindfs
    module Cap
      module RedHat
        module BindfsInstall

          def self.bindfs_install(machine)
            machine.communicate.tap do |comm|
              if comm.test('grep "CentOS release 6" /etc/centos-release')
                comm.sudo('yum -y install fuse fuse-devel')
                comm.sudo('wget http://bindfs.org/downloads/bindfs-1.12.6.tar.gz')
                comm.sudo('tar -zxvf bindfs-1.12.6.tar.gz')
                comm.sudo('cd bindfs-1.12.6')
                comm.sudo('./configure && make && make install')
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
