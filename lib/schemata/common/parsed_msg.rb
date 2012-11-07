require 'schemata/helpers/hash_copy'
require 'set'
require 'yajl'

module Schemata
  class ParsedMessage

    attr_reader :version, :min_version

    def initialize(json)
      @contents = Yajl::Parser.parse(json)

      @min_version = @contents['min_version']
      if !@min_version
        raise DecodeError.new("Field 'min_version' abset from message")
      end

      versions = []
      @contents.keys.each do |k|
        next if k == 'min_version'
        unless k =~ /^V[0-9]+$/
          raise DecodeError.new("Invalid key: #{k}")
        end
        versions << k[1..-1].to_i
      end

      if versions.empty?
        raise DecodeError.new("Message contains no versioned hashes")
      end

      if Set.new(versions.min..versions.max) != Set.new(versions)
        raise DecodeError.new("There are versions missing between\
 #{versions.min} and #{versions.max}")
      end

      @version = versions.max
    end

    def contents
      Schemata::HashCopyHelpers.deep_copy(@contents)
    end
  end
end
