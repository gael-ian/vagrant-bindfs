# frozen_string_literal: true

module VagrantBindfs
  module Bindfs
    SOURCE_VERSION = '1.17.2'
    SOURCE_URLS = [
      'https://bindfs.org/downloads/%<basename>s.tar.gz',
      'https://bindfs.dy.fi/downloads/%<basename>s.tar.gz'
    ].freeze

    autoload :Command, 'vagrant-bindfs/bindfs/command'
    autoload :Folder, 'vagrant-bindfs/bindfs/folder'
    autoload :OptionSet, 'vagrant-bindfs/bindfs/option_set'
    autoload :Validators, 'vagrant-bindfs/bindfs/validators'

    class << self
      FULL_VERSION_NUMBER_SINCE = '1.13.0'

      def source_tar_basename(version)
        ['bindfs', normalize_version_in_tar_name(version)].join('-')
      end

      def source_tar_urls(version)
        SOURCE_URLS.map { |url| format(url, basename: source_tar_basename(version)) }
      end

      def normalize_version_in_tar_name(version)
        v = version.to_s.strip
        parts = (v.split('.').map(&:to_i) + [0, 0, 0]).take(3).compact
        parts.pop if parts.last.zero? && Gem::Version.new(v) < Gem::Version.new(FULL_VERSION_NUMBER_SINCE)
        parts.join('.')
      end
    end
  end
end
