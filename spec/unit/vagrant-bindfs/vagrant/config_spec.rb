# frozen_string_literal: true

describe VagrantBindfs::Vagrant::Config do
  subject { described_class.new }

  it 'has an option to enable/disable debugging' do
    expect(subject).to respond_to(:debug)
    expect(subject).to respond_to(:debug=)
  end

  describe '#debug' do
    it 'should force the debug option to a boolean' do
      subject.debug = 'true'
      expect(subject.debug).to be false
    end
  end

  it 'has an option to enable/disable installation of bindfs from sources' do
    expect(subject).to respond_to(:install_bindfs_from_source)
    expect(subject).to respond_to(:install_bindfs_from_source=)
  end

  describe '#install_bindfs_from_source' do
    it 'should force the option to a boolean' do
      subject.install_bindfs_from_source = 'true'
      expect(subject.install_bindfs_from_source).to be false
    end
  end

  it 'has an option for bindfs version when installed from sources' do
    expect(subject).to respond_to(:bindfs_version)
    expect(subject).to respond_to(:bindfs_version=)
  end

  describe '#bindfs_version=' do
    it 'should convert given version to a Gem::Version instance' do
      subject.source_version = '1.0.0'
      expect(subject.bindfs_version).to eq(Gem::Version.new('1.0.0'))
    end
  end

  it 'has an option for default bindfs options' do
    expect(subject).to respond_to(:default_options)
    expect(subject).to respond_to(:default_options=)
  end

  describe '#default_options' do
    it 'should not carry a default set' do
      expect(subject.default_options).not_to be_a(VagrantBindfs::Bindfs::OptionSet)
    end
  end

  describe '#default_options=' do
    it 'should convert options to an instance of VagrantBindfs::Command::OptionSet' do
      subject.default_options = {
        group: 'dummy',
        user: 'dummy'
      }

      expect(subject.default_options).to be_a(VagrantBindfs::Bindfs::OptionSet)
      expect(subject.default_options.keys).to contain_exactly('force-group', 'force-user')
    end
  end

  it 'has an option for bound folders set' do
    expect(subject).to respond_to(:bound_folders)
  end

  describe '#bind_folder' do
  end

  describe '#merge' do
    describe 'with full config objects' do
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

      subject { first.merge(second) }

      it 'should pick the most verbose value for debug options' do
        expect(subject.debug).to be(true)
      end

      it 'should merge default bindfs options' do
        expect(subject.default_options.keys).to contain_exactly('perms', 'create-as-user', 'create-as-mounter')
        expect(subject.default_options['perms']).to be second.default_options['perms']
        expect(subject.default_options['create-as-user']).to be true
        expect(subject.default_options['create-as-mounter']).to be true
      end

      it 'should merge bound folders set' do
        expect(subject.bound_folders.collect { |(_, f)| f.destination }).to include('/etc-bound', '/usr-bin-bound', '/bin-bound')
      end

      it 'should merge skip_validations set' do
        expect(subject.skip_validations).to contain_exactly(:user, :group)
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

      it 'should merge default bindfs options' do
        merged = first.merge(second)
        expect(merged.default_options.keys).to contain_exactly('perms')
        expect(merged.default_options['perms']).to be second.default_options['perms']

        merged = second.merge(first)
        expect(merged.default_options.keys).to contain_exactly('perms')
        expect(merged.default_options['perms']).to be second.default_options['perms']
      end

      it 'should not merge default bindfs options if unset' do
        merged = first.merge(first)
        expect(merged.default_options).not_to be_a(VagrantBindfs::Bindfs::OptionSet)
      end
    end
  end

  it 'should respond to #finalize!' do
    expect(subject).to respond_to(:finalize!)
  end

  context 'when finalized' do
    before { subject.finalize! }

    it 'defaults to disable debug' do
      expect(subject.debug).to eq(false)
    end

    it 'defaults to install bindfs from sources of the latest supported version' do
      expect(subject.bindfs_version).to eq(:latest)
    end

    it 'defaults to basics bindfs options' do
      expect(subject.default_options.keys).to contain_exactly('force-user', 'force-group', 'perms')
    end

    it 'defaults to empty bound folders set' do
      expect(subject.bound_folders).to eq({})
    end

    it 'defaults to empty skip_validations set' do
      expect(subject.skip_validations).to eq([])
    end
  end

  it 'should respond to #validate' do
    expect(subject).to respond_to(:validate)
  end

  describe '#validate' do
    it 'should return a hash of errors' do
    end
  end
end
