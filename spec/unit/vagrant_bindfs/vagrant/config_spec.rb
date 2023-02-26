# frozen_string_literal: true

describe VagrantBindfs::Vagrant::Config do
  subject(:config) { described_class.new }

  it 'has an option to enable/disable debugging' do
    expect(config).to respond_to(:debug).and(respond_to(:debug=))
  end

  describe '#debug' do
    it 'forces the debug option to a boolean' do
      config.debug = 'true'
      expect(config.debug).to be false
    end
  end

  it 'has an option to enable/disable installation of bindfs from sources' do
    expect(config).to respond_to(:install_bindfs_from_source).and(respond_to(:install_bindfs_from_source=))
  end

  describe '#install_bindfs_from_source' do
    it 'forces the option to a boolean' do
      config.install_bindfs_from_source = 'true'
      expect(config.install_bindfs_from_source).to be false
    end
  end

  it 'has an option for bindfs version when installed from sources' do
    expect(config).to respond_to(:bindfs_version).and(respond_to(:bindfs_version=))
  end

  describe '#bindfs_version=' do
    it 'converts given version to a Gem::Version instance' do
      config.source_version = '1.0.0'
      expect(config.bindfs_version).to eq(Gem::Version.new('1.0.0'))
    end
  end

  it 'has an option for default bindfs options' do
    expect(config).to respond_to(:default_options).and(respond_to(:default_options=))
  end

  describe '#default_options' do
    it 'does not carry a default set' do
      expect(config.default_options).not_to be_a(VagrantBindfs::Bindfs::OptionSet)
    end
  end

  describe '#default_options=' do
    it 'converts options to an instance of VagrantBindfs::Command::OptionSet' do
      config.default_options = { group: 'dummy', user: 'dummy' }
      expect(config.default_options).to be_a(VagrantBindfs::Bindfs::OptionSet)
    end

    it 'normalizes options names' do
      config.default_options = { group: 'dummy', user: 'dummy' }
      expect(config.default_options.keys).to contain_exactly('force-group', 'force-user')
    end
  end

  it 'has an option for bound folders set' do
    expect(config).to respond_to(:bound_folders)
  end

  it '#bind_folder'

  describe '#merge' do
    describe 'with full config objects' do
      subject(:config) { first.merge(second) }

      let(:first) do
        config = described_class.new

        config.debug = false
        config.default_options = { perms: 'u=rwX', create_as_user: true }
        config.skip_validations << :user
        config.bind_folder '/bin', '/bin-bound'
        config.bind_folder '/etc', '/etc-bound', user: 'dummy', create_as_user: false

        config
      end

      let(:second) do
        config = described_class.new

        config.debug = true
        config.default_options = { perms: 'g=rwX', create_as_mounter: true }
        config.skip_validations << :group
        config.bind_folder '/etc', '/etc-bound', group: 'dummy', create_as_user: true
        config.bind_folder '/usr/bin', '/usr-bin-bound'

        config
      end

      it 'picks the most verbose value for debug options' do
        expect(config.debug).to be(true)
      end

      it 'merges default bindfs options' do
        expect(config.default_options.to_h).to contain_exactly('perms' => second.default_options['perms'],
                                                               'create-as-user' => true,
                                                               'create-as-mounter' => true)
      end

      it 'merges bound folders set' do
        expect(config.bound_folders.collect { |(_, f)| f.destination }).to include('/etc-bound',
                                                                                   '/usr-bin-bound',
                                                                                   '/bin-bound')
      end

      it 'merges skip_validations set' do
        expect(config.skip_validations).to contain_exactly(:user, :group)
      end
    end

    describe 'with partially unset config objects' do
      let(:first) do
        config = described_class.new
        config.bind_folder '/bin', '/bin-bound'
        config
      end

      let(:second) do
        config = described_class.new
        config.default_options = { perms: 'g=rwX' }
        config
      end

      it 'merges default bindfs options' do
        merged = first.merge(second)
        expect(merged.default_options.keys).to contain_exactly('perms' => second.default_options['perms'])
      end

      it 'works the other way round' do
        merged = second.merge(first)
        expect(merged.default_options.keys).to contain_exactly('perms' => second.default_options['perms'])
      end

      it 'does not merge default bindfs options if unset' do
        merged = first.merge(first)
        expect(merged.default_options).not_to be_a(VagrantBindfs::Bindfs::OptionSet)
      end
    end
  end

  it 'responds to #finalize!' do
    expect(config).to respond_to(:finalize!)
  end

  context 'when finalized' do
    before { config.finalize! }

    it 'defaults to disable debug' do
      expect(config.debug).to be(false)
    end

    it 'defaults to install bindfs from sources of the latest supported version' do
      expect(config.bindfs_version).to eq(:latest)
    end

    it 'defaults to basics bindfs options' do
      expect(config.default_options.keys).to contain_exactly('force-user', 'force-group', 'perms')
    end

    it 'defaults to empty bound folders set' do
      expect(config.bound_folders).to eq({})
    end

    it 'defaults to empty skip_validations set' do
      expect(config.skip_validations).to eq([])
    end
  end

  it 'responds to #validate' do
    expect(config).to respond_to(:validate)
  end

  describe '#validate' do
    it 'returns a hash of errors'
  end
end
