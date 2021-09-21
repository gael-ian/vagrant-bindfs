# frozen_string_literal: true

describe VagrantBindfs::Bindfs::Command do
  let(:folder) { VagrantBindfs::Bindfs::Folder.new(:synced_folder, '/etc', '/etc-bound', options) }
  let(:options) do
    {
      force_user: 'vagrant',
      force_group: 'vagrant',
      chown_deny: true,
      o: 'debug,allow_others',
      r: true
    }
  end

  context 'with recent versions of bindfs' do
    subject(:command) { described_class.new(folder) }

    before { folder.to_version!('1.13.3') }

    it 'builds bindfs command as expected' do
      expect(command.to_s).to eq('bindfs --force-user=vagrant --force-group=vagrant --chown-deny -o debug,allow_others -r /etc /etc-bound')
    end
  end

  context 'with older versions of bindfs' do
    subject(:command) { described_class.new(folder) }

    before { folder.to_version!('1.11') }

    it 'builds bindfs command as expected' do
      expect(command.to_s).to eq('bindfs --user=vagrant --group=vagrant --chown-deny -o debug,allow_others -r /etc /etc-bound')
    end
  end
end
