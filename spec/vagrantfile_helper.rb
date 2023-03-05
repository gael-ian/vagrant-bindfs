# frozen_string_literal: true

def tests_setup(machine, options = {}) # rubocop:disable Metrics/MethodLength
  machine.bindfs.bind_folder '/etc',
                             '/etc-bound-after-synced-folder',
                             options.merge(owner: 'root')

  machine.bindfs.bind_folder '/etc',
                             '/etc-bound-after-provisioning',
                             options.merge(owner: 'root', after: :provision)

  machine.vm.provision :shell do |p|
    p.name   = 'create non emtpy mountpoints'
    p.inline = <<-COMMANDS
      mkdir -p /home/vagrant/mountpoint/non/empty
      mkdir -p /home/vagrant/mountpoint-nonempty/non/empty
    COMMANDS
  end

  machine.bindfs.bind_folder '/etc',
                             '/home/vagrant/mountpoint',
                             options.merge(owner: 'root', after: :provision)

  machine.bindfs.bind_folder '/etc',
                             '/home/vagrant/mountpoint-nonempty',
                             options.merge(owner: 'root', after: :provision)
end
