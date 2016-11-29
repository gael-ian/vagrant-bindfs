# frozen_string_literal: true
describe VagrantBindfs::Bindfs::Folder do
  subject do
    described_class.new(:synced_folders, '/etc', '/etc-binded',
                        force_user: 'vagrant', force_group: 'vagrant', uid_offset: 50)
  end

  it 'should store binding arguments' do
    expect(subject).to respond_to(:source)
    expect(subject).to respond_to(:destination)
    expect(subject).to respond_to(:options)
  end

  it 'should relate to a binding hook' do
    expect(subject).to respond_to(:hook)
  end

  it 'should merge additional options' do
    subject.merge!(force_user: 'another-user', mirror_only: 'joe,bob')
    expect(subject.options.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'uid-offset')
    expect(subject.options['force-user']).to eq('another-user')
  end

  it 'should merge additional options without loss' do
    subject.reverse_merge!(force_user: 'another-user', mirror_only: 'joe,bob')
    expect(subject.options.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'uid-offset')
    expect(subject.options['force-user']).to eq('vagrant')
  end

  it 'should be losslessly convertible to another bindfs version' do
    subject.to_version!('1.13.1')
    expect(subject.options.keys).to contain_exactly('force-user', 'force-group')
    subject.to_version!('1.13.3')
    expect(subject.options.keys).to contain_exactly('force-user', 'force-group', 'uid-offset')
  end
end
