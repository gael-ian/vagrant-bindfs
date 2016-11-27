module VagrantBindfs
  class Action

    def initialize(app, env, hook)
      @app  = app
      @env  = env
      @hook = hook
    end

    def call(env)
      @app.call(env)
      apply!(env)
    end

    protected

    def apply!(env)
      @env      = env
      @machine  = env[:machine]

      return if binded_folders.empty?

      handle_bindfs_installation!
      bind_folders!
    end

    def binded_folders
      @binded_folders ||= begin
        @machine.config.bindfs.binded_folders.reduce({}) do |binded, (id, folder)|
          binded[id] = folder if folder.hook == @hook
          binded
        end
      end
    end

    def handle_bindfs_installation!
      unless @machine.guest.capability(:bindfs_installed)
        @env[:ui].warn(I18n.t("vagrant.config.bindfs.not_installed"))

        unless @machine.guest.capability(:install_bindfs)
          raise VagrantBindfs::Error, :cannot_install
        end
      end

      unless @machine.guest.capability(:fuse_loaded)
        @env[:ui].warn(I18n.t("vagrant.config.bindfs.not_loaded"))

        unless @machine.guest.capability(:enable_fuse)
          raise VagrantBindfs::Error, :cannot_enable_fuse
        end
      end
    end

    def bind_folders!
      @env[:ui].info I18n.t("vagrant.config.bindfs.status.binding_all")

      binded_folders.each do |_, folder|

        folder.merge!(@machine.config.bindfs.default_options)
        folder.to_version!(bindfs_version)

        validator = VagrantBindfs::Bindfs::Validator.new(folder, @machine)

        unless validator.valid?
          @env[:ui].error I18n.t(
            "vagrant-bindfs.validations.errors_found",
            dest:   folder.destination,
            source: folder.source,
            errors: validator.errors.join(' ')
          )
          next
        end

        command = VagrantBindfs::Bindfs::Command.new(folder)

        @env[:ui].info I18n.t(
          "vagrant.config.bindfs.status.binding_entry",
          dest: folder.destination,
          source: folder.source
        )

        @machine.communicate.tap do |comm|
          comm.sudo("mkdir -p #{folder.destination}")
          comm.sudo(command.to_s, error_class: Error, error_key: :binding_failed)
          @env[:ui].info(command.to_s) if @machine.config.bindfs.debug
        end
      end
    end

    def bindfs_version
      @bindfs_version ||= begin
        version = catch(:version) do
          [
              %{sudo bindfs --version | cut -d" " -f2},
              %{sudo -i bindfs --version | cut -d" " -f2}
          ].each do |command|
            @machine.communicate.execute(command) do |type, output|
              @env[:ui].info("#{command}: #{output.inspect}") if @machine.config.bindfs.debug

              version = output.strip
              throw(:version, Gem::Version.new(version)) if version.length > 0 && Gem::Version.correct?(version)
            end
          end
          Gem::Version.new("0.0")
        end
        @env[:ui].info("Detected bindfs version: #{version}") if @machine.config.bindfs.debug
        version
      end
    end

  end
end
