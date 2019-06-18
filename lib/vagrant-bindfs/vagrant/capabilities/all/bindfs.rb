# frozen_string_literal: true

module VagrantBindfs
  module Vagrant
    module Capabilities
      module All
        module Bindfs
          class << self
            def bindfs_bindfs_full_path(machine)
              machine.communicate.execute('bash -c "type -P bindfs || true"') do |_, output|
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
              tar_urls = VagrantBindfs::Bindfs.source_tar_urls(version)
              tar_dirname = VagrantBindfs::Bindfs.source_tar_basename(version)

              begin
                machine.communicate.execute INSTALL_SCRIPT.format(urls: tar_urls, dirname: tar_dirname)
              ensure
                machine.communicate.execute('[ -f ./bindfs.tar.gz ] && rm ./bindfs.tar.gz')
                machine.communicate.execute("[ -d ./#{tar_dirname} ] && rm -rf ./#{tar_dirname}")
              end
            end

            INSTALL_SCRIPT = <<-SHELL
              for u in "%<urls>s"; do
                if wget -q --spider $u; then
                  url=$u;
                  break;
                fi;
              done;
              [ -n "$url" ]               && \
              wget $url -O bindfs.tar.gz  && \
              tar -zxvf bindfs.tar.gz     && \
              [ -d ./%<dirname>s ]        && \
              cd %<dirname>s              && \
              ./configure                 && \
              make                        && \
              sudo make install
            SHELL
          end
        end
      end
    end
  end
end
