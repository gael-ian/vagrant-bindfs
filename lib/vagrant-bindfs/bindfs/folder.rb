# frozen_string_literal: true

require 'digest/sha1'

module VagrantBindfs
  module Bindfs
    class Folder # :nodoc:
      attr_reader :source,
                  :destination,
                  :options,
                  :hook

      def initialize(hook, source, destination, options = {})
        @hook = hook

        @source = source
        @destination = destination
        @options = Bindfs::OptionSet.new(nil, options)
      end

      def id
        @id ||= Digest::SHA1.new.digest(destination)
      end

      def reverse_merge!(options)
        @options = Bindfs::OptionSet.new(nil, options).merge(@options)
      end

      def merge!(options)
        @options = @options.merge(options)
      end

      def to_version!(version)
        @options = @options.to_version(version)
      end
    end
  end
end
