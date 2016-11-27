describe VagrantBindfs::Config do
  subject { described_class.new }


  it "has an option to enable/disable debugging" do
    expect(subject).to respond_to(:debug)
    expect(subject).to respond_to(:debug=)
  end

  describe "#debug" do
    it "should force the debug option to a boolean" do
      subject.debug = 'true'
      expect(subject.debug).to be false
    end
  end

  it "has an option for bindfs version when installed from sources" do
    expect(subject).to respond_to(:source_version)
    expect(subject).to respond_to(:source_version=)
  end

  describe "#source_version=" do
    it "should convert given version to a Gem::Version instance" do
      subject.source_version = "1.0.0"
      expect(subject.source_version).to eq(Gem::Version.new("1.0.0"))
    end
  end

  it "has an option for default bindfs options" do
    expect(subject).to respond_to(:default_options)
    expect(subject).to respond_to(:default_options=)
  end

  describe "#default_options" do
    it "should be an instance of VagrantBindfs::Command::OptionSet" do
      expect(subject.default_options).to be_a(VagrantBindfs::Bindfs::OptionSet)
    end
  end

  describe "#default_options=" do
    it "should convert options to an instance of VagrantBindfs::Command::OptionSet" do
      subject.default_options = {
        group:  "dummy",
        user:   "dummy"
      }

      expect(subject.default_options).to be_a(VagrantBindfs::Bindfs::OptionSet)
      expect(subject.default_options.keys).to contain_exactly('force-group', 'force-user')
    end
  end

  it "has an option for binded folders set" do
    expect(subject).to respond_to(:binded_folders)
  end


  describe "#bind_folder" do

  end


  describe "#merge" do

    let(:first) do
      config = described_class.new

      config.debug = false
      config.default_options = { create_as_user: true }
      config.bind_folder "/bin", "/bin-binded"
      config.bind_folder "/etc", "/etc-binded", user: "dummy", create_as_user: false

      config
    end

    let(:second) do
      config = described_class.new

      config.debug = true
      config.default_options = { create_as_mounter: true }
      config.bind_folder "/etc", "/etc-binded", group: "dummy", create_as_user: true
      config.bind_folder "/usr/bin", "/usr-bin-binded"

      config
    end

    subject { first.merge(second) }

    it "should pick the most verbose value for debug options" do
      expect(subject.debug).to be(true)
    end

    it "should merge default bindfs options" do
      expect(subject.default_options.keys).to contain_exactly('create-as-user', 'create-as-mounter')
      expect(subject.default_options['create-as-user']).to be true
      expect(subject.default_options['create-as-mounter']).to be true
    end

    it "should merge binded folders set" do
      expect(subject.binded_folders.keys).to include("/etc-binded", "/usr-bin-binded", "/bin-binded")
    end

  end

  it "should respond to #finalize!" do
    expect(subject).to respond_to(:finalize!)
  end

  context "when finalized" do
    before{ subject.finalize! }

    it "defaults to disable debug" do
      expect(subject.debug).to eq(false)
    end

    it "defaults to install bindfs from sources of the latest supported version" do
      expect(subject.source_version.to_s).to eq(VagrantBindfs::SOURCE_VERSION)
    end

    it "defaults to empty default bindfs options" do
      expect(subject.default_options.keys.count).to eq(0)
    end

    it "defaults to empty binded folders set" do
      expect(subject.binded_folders).to eq({})
    end
  end


  it "should respond to #validate" do
    expect(subject).to respond_to(:validate)
  end

  describe "#validate" do
    it "should return a hash of errors" do

    end
  end
end
