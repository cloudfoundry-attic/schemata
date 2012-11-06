require 'membrane'
require File.expand_path('../../../helpers/hash_copy', __FILE__)
require File.expand_path('../base', __FILE__)

module Schemata
  module Component
    module Foo
    end
  end
end

module Schemata::Component::Foo
  class V10

    SCHEMA = Membrane::SchemaParser.parse do
      {
        "foo1" => String,
        "foo2" => Integer
      }
    end

    MOCK_VALUES = {
      "foo1" => "foo",
      "foo2" => 2
    }

    MIN_VERSION_ALLOWED = 10

    def self.upvert(old_data)
      raise Schemata::DecodeError.new("Upvert called a version that does not exist")
    end

  ############################################

    def schema
      SCHEMA
    end

    def aux_schema
      nil
    end

    def self.mock_values
      MOCK_VALUES
    end

    include Schemata::Component::Foo::Base
    extend Schemata::Component::Foo::Mocking
  end
end
