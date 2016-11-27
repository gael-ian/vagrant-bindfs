module VagrantBindfs
  module Vagrant
    module Capabilities
      module All
        module Bindfs
          class << self

            def bindfs_bindfs_installed(machine)
              machine.communicate.test("bindfs --help")
            end

            def bindfs_bindfs_version(machine)
              [ %{sudo bindfs --version | cut -d" " -f2}, %{sudo -i bindfs --version | cut -d" " -f2} ].each do |command|
                machine.communicate.execute(command) do |_, output|
                  version = output.strip
                  return Gem::Version.new(version) if version.length > 0 && Gem::Version.correct?(version)
                end
              end
              Gem::Version.new("0.0")
            end

            def bindfs_bindfs_install_from_source(machine)
              machine.communicate.tap do |comm|
                if comm.test("test 0 -eq $(sudo yum search bindfs 2>&1 >/dev/null | wc -l)")
                  comm.sudo("yum -y install bindfs")
                else
                  comm.sudo("yum -y install fuse fuse-devel gcc wget tar make")
                  comm.sudo <<-SHELL
                  for u in "#{source_urls(machine).join('" "')}"; do
                    if wget -q --spider $u; then
                      url=$u;
                      break;
                    fi;
                  done;
                  [ -n "$url" ]                               && \
                  wget $url -O bindfs.tar.gz                  && \
                  tar --overwrite -zxvf bindfs.tar.gz         && \
                  [ -d ./bindfs-#{source_version(machine)} ]  && \
                  cd bindfs-#{source_version(machine)}        && \
                  ./configure                                 && \
                  make                                        && \
                  make install                                && \
                  ln -s /usr/local/bin/bindfs /usr/bin
                  SHELL
                end
              end
            end

            protected

            def source_urls(machine)
              SOURCE_URLS.map{ |url| url.gsub('%{source_version}', source_version(machine)) }
            end

            def source_version(machine)
              machine.config.bindfs.source_version
            end

          end
        end
      end
    end
  end
end
