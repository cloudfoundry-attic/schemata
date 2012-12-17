module Schemata
  module Helpers
    def self.decamelize(str)
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
  end
end
