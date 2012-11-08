require 'membrane'
require File.expand_path('../base', __FILE__)
require File.expand_path('../../../helpers/hash_copy', __FILE__)

module Schemata
  module Component
    module Foo
    end
  end
end

module Schemata::Component::Foo
  class V12
    SCHEMA = Membrane::SchemaParser.parse do
      {
        "foo1" => String,
        "foo2" => Integer,
        "foo3" => [Integer]
      }
    end

    MOCK_VALUES = {
      "foo1" => "foo",
      "foo2" => 2,
      "foo3" => lambda { [Random.rand(11)] }
    }

    MIN_VERSION_ALLOWED = 10

    def self.upvert(old_data)
      begin
        Schemata::Component::Foo::V11::SCHEMA.validate(old_data)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end
      new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
      new_data["foo3"] = [old_data["foo3"]]
      new_data
    end

    def generate_old_fields(aux_data = nil)
      first = foo3.length > 0 ? foo3[0] : 1
      old_fields = { "foo3" => first }

      old_contents = contents
      old_fields.each do |k, v|
        old_contents[k] = v
      end
      old_msg = Schemata::Component::Foo::V11.new(old_contents)
      return old_msg, old_fields
    end

  #############################################

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
