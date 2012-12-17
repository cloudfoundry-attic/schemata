module Schemata
  module ComponentBase
    def decamelize(str)
      words = []
      curr_word = ""
      0.upto(str.length - 1) do |i|
        ch = str[i]
        if ch =~ /[A-Z]/
          words.push(curr_word)
          curr_word = ""
        end
        curr_word += ch
      end
      words.push(curr_word)
      words.map! { |x| x.downcase }

      # If the first letter is capitalized, then the first word here is empty
      words.shift if words[0] == ""

      words.join('_')
    end

    def message_types
      self.constants.select { |x| x != :VERSION }
    end

    def component_name
      self.name.split("::")[1]
    end

    def eigenclass
      class << self; self; end
    end

    def register_mock_methods
      message_types.each do |type|
        message_type = self::const_get(type)
        eigenclass.send(:define_method, "mock_#{decamelize(type.to_s)}") do |*args|
          version = args[0] || message_type.current_version
          message_type::const_get("V#{version}").mock
        end
      end
    end

    def require_message_classes
      Dir.glob("./lib/schemata/#{decamelize(component_name)}/*.rb", &method(:require))
    end

    def self.extended(klass)
      klass.require_message_classes
      klass.register_mock_methods
    end

  end
end
