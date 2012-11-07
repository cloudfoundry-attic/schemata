require 'membrane'
require 'schemata/common/msgbase'
require 'schemata/helpers/hash_copy'

module Schemata
  module Component
    module Bar
    end
  end
end

module Schemata::Component::Bar
  class V10
    include Schemata::MessageBase

    SCHEMA = Membrane::SchemaParser.parse do
      {
        "bar1" => String,
        "bar2" => String,
      }
    end

    MOCK_VALUES = {
      "bar1" => "first",
      "bar2" => "second"
    }

    MIN_VERSION_ALLOWED = 10

    def self.upvert(old_data)
      raise NotImplementedError.new
    end

    def generate_old_fields
      raise NotImplementedError.new
    end
  end
end
