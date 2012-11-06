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
  class V11

    SCHEMA = Membrane::SchemaParser.parse do
      {
        "foo1" => String,
        "foo2" => Integer,
        "foo3" => Integer
      }
    end

    MOCK_VALUES = {
      "foo1" => "foo",
      "foo2" => 2,
      "foo3" => 3
    }

    MIN_VERSION_ALLOWED = 10

    DEFAULT_FOO3 = 1
    def self.upvert(old_data)
      begin
        Schemata::Component::Foo::V10::SCHEMA.validate(old_data)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end
      new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
      new_data["foo3"] = DEFAULT_FOO3
      new_data
    end

    def generate_old_fields(aux_data = nil)
      # empty
      return Schemata::Component::Foo::V10.new(contents), {}
    end

  ##########################################

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
