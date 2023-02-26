# frozen_string_literal: true

# rubocop:disable RSpec/MultipleExpectations
describe VagrantBindfs::Bindfs do
  subject(:bindfs) { described_class }

  describe 'normalize_version_in_tar_name' do
    it 'strips bindfs old version number to match tarballs names' do
      expect(bindfs.normalize_version_in_tar_name('1.12')).to eq('1.12')
      expect(bindfs.normalize_version_in_tar_name('1.12.0')).to eq('1.12')
    end

    it 'keeps new bindfs version number identical to match tarballs names' do
      expect(bindfs.normalize_version_in_tar_name('1.13')).to eq('1.13.0')
      expect(bindfs.normalize_version_in_tar_name('1.13.0')).to eq('1.13.0')
    end
  end

  describe 'source_tar_basename' do
    it 'return correct tarball names' do
      expect(bindfs.source_tar_basename('1.12')).to eq('bindfs-1.12')
      expect(bindfs.source_tar_basename('1.13')).to eq('bindfs-1.13.0')
    end
  end

  describe 'source_tar_urls' do
    it 'return correct tarball urls' do
      expect(bindfs.source_tar_urls('1.12')).to include('https://bindfs.org/downloads/bindfs-1.12.tar.gz')
      expect(bindfs.source_tar_urls('1.13')).to include('https://bindfs.org/downloads/bindfs-1.13.0.tar.gz')
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
