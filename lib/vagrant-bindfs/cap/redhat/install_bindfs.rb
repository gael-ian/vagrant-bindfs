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
                comm.sudo("yum -y install fuse fuse-devel gcc wget tar make")
                comm.sudo <<-SHELL
                for u in "#{SOURCE_URLS.join('" "')}"; do
                  if wget -q --spider $u; then
                    url=$u;
                    break;
                  fi;
                done;
                [ -n "$url" ]                         && \
                wget $url -O bindfs.tar.gz            && \
                tar --overwrite -zxvf bindfs.tar.gz   && \
                [ -d ./bindfs-#{SOURCE_VERSION} ]     && \
                cd bindfs-#{SOURCE_VERSION}           && \
                ./configure                           && \
                make                                  && \
                make install                          && \
                ln -s /usr/local/bin/bindfs /usr/bin
                SHELL
              end
            end
          end

        end
      end
    end
  end
end
