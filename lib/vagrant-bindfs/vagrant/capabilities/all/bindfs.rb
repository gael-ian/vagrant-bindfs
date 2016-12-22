# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module All
        module Bindfs
          class << self
            def bindfs_bindfs_full_path(machine)
              machine.communicate.execute('type -p bindfs | cut -d" " -f3') do |_, output|
                path = output.strip
                return path unless path.empty?
              end
              'bindfs'
            end

            def bindfs_bindfs_installed(machine)
              bindfs_full_path = machine.guest.capability(:bindfs_bindfs_full_path)
              machine.communicate.test("#{bindfs_full_path} --help")
            end

            def bindfs_bindfs_version(machine)
              bindfs_full_path = machine.guest.capability(:bindfs_bindfs_full_path)
              [%(sudo #{bindfs_full_path} --version | cut -d" " -f2), %(sudo -i #{bindfs_full_path} --version | cut -d" " -f2)].each do |command|
                machine.communicate.execute(command) do |_, output|
                  version = output.strip
                  return Gem::Version.new(version) if !version.empty? && Gem::Version.correct?(version)
                end
              end
              Gem::Version.new('0.0')
            end

            def bindfs_bindfs_install_from_source(machine, version)
              version     = version.to_s.strip.gsub(/\.0$/, '')
              source_urls = VagrantBindfs::Bindfs::SOURCE_URLS.map { |url| url.gsub('%{bindfs_version}', version) }

              begin
                machine.communicate.execute <<-SHELL
                  for u in "#{source_urls.join('" "')}"; do
                    if wget -q --spider $u; then
                      url=$u;
                      break;
                    fi;
                  done;
                  [ -n "$url" ]               && \
                  wget $url -O bindfs.tar.gz  && \
                  tar -zxvf bindfs.tar.gz     && \
                  [ -d ./bindfs-#{version} ]  && \
                  cd bindfs-#{version}        && \
                  ./configure                 && \
                  make                        && \
                  sudo make install
                SHELL
              ensure
                machine.communicate.execute('[ -f ./bindfs.tar.gz ] && rm ./bindfs.tar.gz')
                machine.communicate.execute("[ -d ./bindfs-#{version} ] && rm -rf ./bindfs-#{version}")
              end
            end
          end
        end
      end
    end
  end
end
