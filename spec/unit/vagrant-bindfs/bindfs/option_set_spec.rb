# frozen_string_literal: true

describe VagrantBindfs::Bindfs::OptionSet do
  it 'should normalize option names' do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'force-user' => 'vagrant',
                                                           'force_group' => 'vagrant',
                                                           :mirror_only => 'joe,bob',
                                                           :'create-as-user' => true)

    expect(option_set.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'create-as-user')
  end

  it 'should canonicalize option names' do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'owner' => 'vagrant',
                                                           :n => true)

    expect(option_set.keys).to contain_exactly('force-user', 'no-allow-other')
  end

  it 'should raise an error when more than one option refers to the same canonical name' do
    expect do
      VagrantBindfs::Bindfs::OptionSet.new(nil, 'owner' => 'vagrant',
                                                'user' => 'another-user')
    end.to raise_error(VagrantBindfs::Vagrant::ConfigError)
  end

  it 'should remove invalid option names' do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'force-user' => 'vagrant',
                                                           'force_group' => 'vagrant',
                                                           :invalid => true)

    expect(option_set.keys).to contain_exactly('force-user', 'force-group')
    expect(option_set.invalid_options.keys).to contain_exactly('invalid')
  end

  it 'should remove unsupported option names' do
    option_set = VagrantBindfs::Bindfs::OptionSet.new('1.13.1', 'force-user' => 'vagrant',
                                                                'force_group' => 'vagrant',
                                                                'uid-offset' => 50)

    expect(option_set.keys).to contain_exactly('force-user', 'force-group')
    expect(option_set.unsupported_options.keys).to contain_exactly('uid-offset')
  end

  it 'should cast option values according to option type' do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'force-user' => :vagrant,
                                                           'force-group' => true,
                                                           'uid-offset' => 50,
                                                           :'create-as-user' => 1,
                                                           'create-as-mounter' => 'off')

    expect(option_set['force-user']).to eq('vagrant')
    expect(option_set['force-group']).to eq('true')
    expect(option_set['uid-offset']).to eq('50')

    expect(option_set['create-as-user']).to be true
    expect(option_set['create-as-mounter']).to be false
  end

  it 'should consider nil as a proper value for non boolean options' do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'force-user' => :vagrant,
                                                           'force-group' => nil,
                                                           'uid-offset' => 50,
                                                           :'create-as-user' => nil)

    expect(option_set['force-user']).to eq('vagrant')
    expect(option_set['force-group']).to eq(nil)

    expect(option_set['uid-offset']).to eq('50')
    expect(option_set['create-as-user']).to be false
  end

  it 'should be mergeable' do
    first_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'force-user' => 'vagrant',
                                                          'force_group' => 'vagrant',
                                                          :invalid => true,
                                                          'perms' => 'u=rwX:g=rD:o=rD')
    second_set = VagrantBindfs::Bindfs::OptionSet.new(nil, 'force_group' => 'other-group',
                                                           'mirror-only' => 'joe,bob',
                                                           :invalid => true,
                                                           'perms' => nil)

    first_set.merge(second_set)

    expect(first_set.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'perms')
    expect(first_set['force-group']).to eq('other-group')
    expect(first_set['perms']).to be nil
  end

  it 'should be losslessly convertible to another version of bindfs' do
    set1132 = VagrantBindfs::Bindfs::OptionSet.new('1.13.2', 'user' => 'vagrant',
                                                             'force_group' => 'vagrant',
                                                             'uid-offset' => 50)
    set1130 = set1132.to_version('1.13.0')
    set1134 = set1130.to_version('1.13.4')

    expect(set1132.keys).to contain_exactly('force-user', 'force-group', 'uid-offset')
    expect(set1132.unsupported_options.keys.size).to eq(0)

    expect(set1130.keys).to contain_exactly('force-user', 'force-group')
    expect(set1130.unsupported_options.keys).to contain_exactly('uid-offset')

    expect(set1134.keys).to contain_exactly('force-user', 'force-group', 'uid-offset')
    expect(set1134.unsupported_options.keys.size).to eq(0)
  end
end
