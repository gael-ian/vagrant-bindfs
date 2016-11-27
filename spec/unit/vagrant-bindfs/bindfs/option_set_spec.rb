describe VagrantBindfs::Bindfs::OptionSet do

  it "should normalize option names" do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, {
      'force-user'        => 'vagrant',
      'force_group'       => 'vagrant',
      :mirror_only        => 'joe,bob',
      :'create-as-user'   => true
    })

    expect(option_set.keys).to contain_exactly('force-user', 'force-group', 'mirror-only', 'create-as-user')
  end

  it "should canonicalize option names" do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, {
      'owner' => 'vagrant',
      :n      => true
    })

    expect(option_set.keys).to contain_exactly('force-user', 'no-allow-other')
  end

  it "should remove invalid option names" do
    option_set = VagrantBindfs::Bindfs::OptionSet.new(nil, {
      'force-user'        => 'vagrant',
      'force_group'       => 'vagrant',
      :invalid            => true
    })

    expect(option_set.keys).to contain_exactly('force-user', 'force-group')
    expect(option_set.invalid_options.keys).to contain_exactly('invalid')
  end

  it "should remove unsupported option names" do
    option_set = VagrantBindfs::Bindfs::OptionSet.new("1.13.1", {
      'force-user'  => 'vagrant',
      'force_group' => 'vagrant',
      'uid-offset'  => 50
    })

    expect(option_set.keys).to contain_exactly('force-user', 'force-group')
    expect(option_set.unsupported_options.keys).to contain_exactly('uid-offset')
  end

  it "should be mergeable" do
    first_set = VagrantBindfs::Bindfs::OptionSet.new(nil, {
        'force-user'        => 'vagrant',
        'force_group'       => 'vagrant',
        :invalid            => true
    })
    second_set = VagrantBindfs::Bindfs::OptionSet.new(nil, {
        'force_group'       => 'other-group',
        'mirror-only'       => 'joe,bob',
        :invalid            => true
    })

    first_set.merge(second_set)

    expect(first_set.keys).to contain_exactly('force-user', 'force-group', 'mirror-only')
    expect(first_set['force-group']).to eq('other-group')
  end

  it "should be losslessly convertible to another version of bindfs" do
    option_set_1_13_2 = VagrantBindfs::Bindfs::OptionSet.new("1.13.2", {
      'user'        => 'vagrant',
      'force_group' => 'vagrant',
      'uid-offset'  => 50
    })
    option_set_1_13_0 = option_set_1_13_2.to_version("1.13.0")
    option_set_1_13_4 = option_set_1_13_0.to_version("1.13.4")

    expect(option_set_1_13_2.keys).to contain_exactly('force-user', 'force-group', 'uid-offset')
    expect(option_set_1_13_2.unsupported_options.keys.size).to eq(0)

    expect(option_set_1_13_0.keys).to contain_exactly('force-user', 'force-group')
    expect(option_set_1_13_0.unsupported_options.keys).to contain_exactly('uid-offset')

    expect(option_set_1_13_4.keys).to contain_exactly('force-user', 'force-group', 'uid-offset')
    expect(option_set_1_13_4.unsupported_options.keys.size).to eq(0)

  end

end
