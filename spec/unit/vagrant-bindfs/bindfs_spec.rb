# frozen_string_literal: true

describe VagrantBindfs::Bindfs do
  describe 'normalize_version_in_tar_name' do
    it 'normalize bindfs version number to match tarballs names' do
      expect(subject.normalize_version_in_tar_name('1.12')).to eq('1.12')
      expect(subject.normalize_version_in_tar_name('1.12.0')).to eq('1.12')
      expect(subject.normalize_version_in_tar_name('1.12.7')).to eq('1.12.7')

      expect(subject.normalize_version_in_tar_name('1.13')).to eq('1.13.0')
      expect(subject.normalize_version_in_tar_name('1.13.0')).to eq('1.13.0')
      expect(subject.normalize_version_in_tar_name('1.13.10')).to eq('1.13.10')
    end
  end

  describe 'source_tar_basename' do
    it 'return correct tarball names' do
      expect(subject.source_tar_basename('1.12')).to eq('bindfs-1.12')
      expect(subject.source_tar_basename('1.13')).to eq('bindfs-1.13.0')
    end
  end

  describe 'source_tar_urls' do
    it 'return correct tarball urls' do
      expect(subject.source_tar_urls('1.12')).to include('https://bindfs.org/downloads/bindfs-1.12.tar.gz')
      expect(subject.source_tar_urls('1.13')).to include('https://bindfs.org/downloads/bindfs-1.13.0.tar.gz')
    end
  end
end
