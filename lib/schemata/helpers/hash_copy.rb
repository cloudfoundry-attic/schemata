module Schemata
  module Helpers
    class CopyError < StandardError; end

    def self.deep_copy(node)
      case node
      when String
        return node.dup
      when Numeric, TrueClass, FalseClass
        return node
      when Hash
        copy = {}
        # XXX NB: The 'to_s' below was included because some components use
        # symbols as keys instead of strings. This fix is temporary; in the
        # long term, we should change all components to use the same type for
        # their keys
        node.each { |k, v| copy[k.to_s] = deep_copy(v) }
        return copy
      when Array
        return node.map { |v| deep_copy(v) }
      when NilClass
        return nil
      else
        raise CopyError.new("Unexpected class: #{node.class}")
      end
    end
  end
end
