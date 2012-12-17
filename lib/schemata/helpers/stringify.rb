module Schemata
  module Helpers

    def self.stringify(node)
      case node
      when String
        return node
      when Numeric, TrueClass, FalseClass
        return node
      when Hash
        copy = {}
        node.each { |k, v| copy[k.to_s] = stringify(v) }
        return copy
      when Array
        return node.map { |v| stringify(v) }
      when NilClass
        return nil
      when Symbol
        return node.to_s
      else
        raise CopyError.new("Unexpected class: #{node.class}")
      end
    end

  end
end
