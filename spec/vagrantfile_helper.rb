# frozen_string_literal: true

def tests_setup(machine, options = {})
  machine.bindfs.bind_folder '/etc',
                             '/etc-binded-after-synced-folder',
                             options.merge(owner: 'root')

  machine.bindfs.bind_folder '/etc',
                             '/etc-binded-after-provisioning',
                             options.merge(owner: 'root', after: :provision)
end
