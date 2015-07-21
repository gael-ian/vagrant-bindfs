module VagrantPlugins
  module Bindfs
    class Command

      attr_reader :source
      attr_reader :destination
      attr_reader :arguments

      def initialize(machine, options)
        @machine = machine
        options  = normalize_keys(options)

        @source       = options.delete("source-path")
        @destination  = options.delete("dest-path")
        @arguments    = arguments_for(default_options.merge(options))
      end

      def build
        [ "bindfs", arguments.join(" "), source, destination ].compact.join(" ")
      end

      def user
        @arguments.join(' ')[/--(?:force-)?user=([^\s]+)/, 1]
      end

      def group
        @arguments.join(' ')[/--(?:force-)?group=([^\s]+)/, 1]
      end

      protected

      def arguments_for(options)
        available_options.reduce([]) do |args, (name, definition)|

          short = definition[:short].detect{ |k| options.key?(k) }
          long  = definition[:long].detect{ |k| options.key?(k) }
          value = case true
                    when !short.nil? then options[short]
                    when !long.nil?  then options[long]
                    else definition[:default]
                  end

          args << format_argument(name, definition, value) unless value.nil?
          args
        end.compact
      end

      def format_argument(name, definition, value)
        if definition[:type] == :flag && !!value
          return "-#{name}" if 0 == definition[:long].size # Shorthand only options
          return "--#{name}"
        end
        if definition[:type] == :option
          return "-#{name} #{value}" if 0 == definition[:long].size # Shorthand only options
          return "--#{name}=#{value}"
        end
      end

      def normalize_keys(opts)
        {}.tap do |hash|
          opts.each do |key, value|
            hash[key.to_s.gsub("_", "-")] = value
          end
        end
      end

      def default_options
        @default_options ||= normalize_keys(@machine.config.bindfs.default_options)
      end

      # TODO: Update after each bindfs release
      def available_options
        @available_options || begin
          options = {
            # File ownership
            "force-user"            => { long: ["force-user", "user", "owner"], short: ["u"], type: :option,  default: "vagrant" },
            "force-group"           => { long: ["force-group", "group"],        short: ["g"], type: :option,  default: "vagrant" },
            "mirror"                => { long: ["mirror"],                      short: ["m"], type: :option,  default: nil },
            "mirror-only"           => { long: ["mirror-only"],                 short: ["M"], type: :option,  default: nil },
            "map"                   => { long: ["map"],                         short: [],    type: :option,  default: nil },

            # Permission bits
            "perms"                 => { long: ["perms"],                       short: ["p"], type: :option,  default: "u=rwX:g=rD:o=rD" },

            # File creation policy
            "create-as-user"        => { long: ["create-as-user"],              short: [],    type: :flag,    default: false },
            "create-as-mounter"     => { long: ["create-as-mounter"],           short: [],    type: :flag,    default: false },
            "create-for-user"       => { long: ["create-for-user"],             short: [],    type: :option,  default: nil },
            "create-for-group"      => { long: ["create-for-group"],            short: [],    type: :option,  default: nil },
            "create-with-perms"     => { long: ["create-with-perms"],           short: [],    type: :option,  default: nil },

            # Chown policy
            "chown-normal"          => { long: ["chown-normal"],                short: [],    type: :flag,    default: false },
            "chown-ignore"          => { long: ["chown-ignore"],                short: [],    type: :flag,    default: false },
            "chown-deny"            => { long: ["chown-deny"],                  short: [],    type: :flag,    default: false },

            # Chgrp policy
            "chgrp-normal"          => { long: ["chgrp-normal"],                short: [],    type: :flag,    default: false },
            "chgrp-ignore"          => { long: ["chgrp-ignore"],                short: [],    type: :flag,    default: false },
            "chgrp-deny"            => { long: ["chgrp-deny"],                  short: [],    type: :flag,    default: false },

            # Chmod policy
            "chmod-normal"          => { long: ["chmod-normal"],                short: [],    type: :flag,    default: false },
            "chmod-ignore"          => { long: ["chmod-ignore"],                short: [],    type: :flag,    default: false },
            "chmod-deny"            => { long: ["chmod-deny"],                  short: [],    type: :flag,    default: false },
            "chmod-filter"          => { long: ["chmod-filter"],                short: [],    type: :option,  default: nil },
            "chmod-allow-x"         => { long: ["chmod-allow-x"],               short: [],    type: :flag,    default: false },

            # Extended attribute policy
            "xattr-none"            => { long: ["xattr-none"],                  short: [],    type: :flag,    default: false },
            "xattr-ro"              => { long: ["xattr-ro"],                    short: [],    type: :flag,    default: false },
            "xattr-rw"              => { long: ["xattr-rw"],                    short: [],    type: :flag,    default: false },

            # Rate limits
            "read-rate"             => { long: ["read-rate"],                   short: [],    type: :option,  default: false },
            "write-rate"            => { long: ["write-rate"],                  short: [],    type: :option,  default: false },

            # Miscellaneous
            "no-allow-other"        => { long: ["no-allow-other"],              short: ["n"], type: :flag,    default: false },
            "realistic-permissions" => { long: ["realistic-permissions"],       short: [],    type: :flag,    default: false },
            "ctime-from-mtime"      => { long: ["ctime-from-mtime"],            short: [],    type: :flag,    default: false },
            "hide-hard-links"       => { long: ["hide-hard-links"],             short: [],    type: :flag,    default: false },
            "multithreaded"         => { long: ["multithreaded"],               short: [],    type: :flag,    default: false },

            # FUSE options
            "o"                     => { long: [],                              short: ["o"], type: :option,  default: nil },
            "r"                     => { long: [],                              short: ["r"], type: :flag,    default: false },
            "d"                     => { long: [],                              short: ["d"], type: :flag,    default: false },
            "f"                     => { long: [],                              short: ["f"], type: :flag,    default: false },
          }

          if bindfs_version_lower_than("1.12.6")
            options.delete("read-rate")
            options.delete("write-rate")
          end

          if bindfs_version_lower_than("1.12.2")
            options.delete("chmod-filter")
          end

          if bindfs_version_lower_than("1.12")
            options["user"]  = options.delete("force-user")
            options["group"] = options.delete("force-group")
          end

          if bindfs_version_lower_than("1.11")
            options.delete("multithreaded")
          end

          if bindfs_version_lower_than("1.10")
            options.delete("map")
            options.delete("realistic-permissions")
            options.delete("hide-hard-links")
          end

          # Can't track changes deeper as SVN repository was removed from https://code.google.com/p/bindfs/

          options
        end
      end

      def bindfs_version_lower_than(version)
        bindfs_version_command = %{sudo bindfs --version | cut -d" " -f2}
        bindfs_version = @machine.communicate.execute(bindfs_version_command);
        Gem::Version.new(bindfs_version) < Gem::Version.new(version)
      end

    end
  end
end
