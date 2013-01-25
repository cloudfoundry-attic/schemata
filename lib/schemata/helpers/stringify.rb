module Schemata
  module Helpers
    class StringifyError < StandardError; end

    def self.stringify_symbols(node)
      case node
      when Hash
        copy = {}
        node.each { |k, v| copy[k.to_s] = stringify_symbols(v) }
        return copy
      when Array
        return node.map { |v| stringify_symbols(v) }
      when Symbol
        return node.to_s
      when String, Numeric, TrueClass, FalseClass, NilClass
        return node
      else
        raise StringifyError.new("Unexpected class: #{node.class}")
      end
    end

  end
end
