# frozen_string_literal: true

describe VagrantBindfs::Bindfs::Command do
  it 'should build bindfs command as expected' do
    options = { force_user: 'vagrant', chown_deny: true, o: 'debug,allow_others', r: true }
    folder = VagrantBindfs::Bindfs::Folder.new(:synced_folder, '/etc', '/etc-bound', options)

    folder.to_version!('1.13.3')
    command = described_class.new(folder)
    expect(command.to_s).to eq('bindfs --force-user=vagrant --chown-deny -o debug,allow_others -r /etc /etc-bound')
  end

  it 'should build bindfs command according to bindfs version' do
    options = { force_user: 'vagrant', force_group: 'vagrant', perms: 'u=rwX:g=rD:o=rD' }
    folder = VagrantBindfs::Bindfs::Folder.new(:synced_folder, '/etc', '/etc-bound', options)

    folder.to_version!('1.13.3')
    command = described_class.new(folder)
    expect(command.to_s).to eq('bindfs --force-user=vagrant --force-group=vagrant --perms=u=rwX:g=rD:o=rD /etc /etc-bound')

    folder.to_version!('1.11')
    command = described_class.new(folder)
    expect(command.to_s).to eq('bindfs --user=vagrant --group=vagrant --perms=u=rwX:g=rD:o=rD /etc /etc-bound')
  end
end
