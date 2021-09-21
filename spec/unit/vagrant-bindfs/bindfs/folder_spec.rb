# frozen_string_literal: true

describe VagrantBindfs::Bindfs::Folder do
  subject(:folder) do
    described_class.new(:synced_folders, '/etc', '/etc-bound',
                        force_user: 'vagrant', force_group: 'vagrant', uid_offset: 50)
  end

  it 'stores source' do
    expect(folder).to respond_to(:source)
  end

  it 'stores destination' do
    expect(folder).to respond_to(:destination)
  end

  it 'stores arguments' do
    expect(folder).to respond_to(:options)
  end

  it 'relates to a binding hook' do
    expect(folder).to respond_to(:hook)
  end

  it 'merges additional options' do
    folder.merge!(force_user: 'another-user', mirror_only: 'joe,bob')
    expect(folder.options.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'uid-offset')
    expect(folder.options['force-user']).to eq('another-user')
  end

  it 'merges additional options without loss' do
    folder.reverse_merge!(force_user: 'another-user', mirror_only: 'joe,bob')
    expect(folder.options.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'uid-offset')
    expect(folder.options['force-user']).to eq('vagrant')
  end

  it 'is convertible to another bindfs version' do
    folder.to_version!('1.13.1')
    expect(folder.options.keys).to contain_exactly('force-user', 'force-group')
  end

  it 'is losslessly convertible to another bindfs version' do
    folder.to_version!('1.13.1')
    folder.to_version!('1.13.3')
    expect(folder.options.keys).to contain_exactly('force-user', 'force-group', 'uid-offset')
  end
end
