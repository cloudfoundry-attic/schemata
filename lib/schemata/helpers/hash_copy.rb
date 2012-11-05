module Schemata
  module HashCopyHelpers
    class CopyError < StandardError; end

    def self.deep_copy(node)
      case node
      when String
        return node.dup
      when Numeric, TrueClass, FalseClass
        return node
      when Hash
        copy = {}
        node.each { |k, v| copy[k] = deep_copy(v) }
        return copy
      when Array
        return node.map { |v| deep_copy(v) }
      else
        raise CopyError.new("Unexpected class: #{node.class}")
      end
    end
  end
end
