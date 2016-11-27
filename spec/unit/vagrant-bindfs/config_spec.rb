describe VagrantBindfs::Config do
  subject { described_class.new }


  it "has an option to enable/disable debugging" do
    expect(subject).to respond_to(:debug)
    expect(subject).to respond_to(:debug=)
  end

  it "has an option for bindfs version when installed from sources" do
    expect(subject).to respond_to(:source_version)
    expect(subject).to respond_to(:source_version=)
  end

  it "has an option for default bindfs options" do
    expect(subject).to respond_to(:default_options)
    expect(subject).to respond_to(:default_options=)
  end

  it "has an option for binded folders set" do
    expect(subject).to respond_to(:bind_folders)
    expect(subject).to respond_to(:bind_folders=)
  end


  describe "#bind_folder" do

  end

  describe "#validate" do

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
      expect(subject.default_options).to eq({
        create_as_user: true,
        create_as_mounter: true
      })
    end

    it "should merge binded folders set" do
      expect(subject.bind_folders.keys).to include("/etc-binded", "/usr-bin-binded", "/bin-binded")
      expect(subject.bind_folders["/etc-binded"]).to include(group: 'dummy', user: 'dummy', create_as_user: true)
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
      expect(subject.source_version).to eq(VagrantBindfs::SOURCE_VERSION)
    end

    it "defaults to empty default bindfs options" do
      expect(subject.default_options).to eq({})
    end

    it "defaults to empty binded folders set" do
      expect(subject.bind_folders).to eq({})
    end
  end
end
