require "vagrant-bindfs/version"

module VagrantPlugins
  module Bindfs
    module Cap
      module RedHat
        module InstallBindfs

          def self.install_bindfs(machine)
            machine.communicate.tap do |comm|
              if comm.test("test 0 -eq $(sudo yum search bindfs 2>&1 >/dev/null | wc -l)")
                comm.sudo("yum -y install bindfs")
              else
                comm.sudo("yum -y install fuse fuse-devel gcc wget")
                comm.sudo("wget #{SOURCE_URL} -O bindfs.tar.gz")
                comm.sudo("tar --overwrite -zxvf bindfs.tar.gz")
                comm.sudo("[ -d ./bindfs-#{SOURCE_VERSION} ] && cd bindfs-#{SOURCE_VERSION} && ./configure && make && make install")
                comm.sudo("ln -s /usr/local/bin/bindfs /usr/bin")
              end
            end
          end

        end
      end
    end
  end
end
