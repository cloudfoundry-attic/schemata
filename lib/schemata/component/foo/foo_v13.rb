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
  class V13
    SCHEMA = Membrane::SchemaParser.parse do
      {
        "foo1" => String,
        "foo3" => [Integer],
        "foo4" => String
      }
    end

    MOCK_VALUES = {
      "foo1" => "foo",
      "foo3" => lambda { [Random.rand(11)] },
      "foo4" => Proc.new do
        time = Time.now
        time.to_s
      end
    }

    MIN_VERSION_ALLOWED = 13

    FOO4_DEFAULT = "foo"

    def self.upvert(old_data)
      begin
        Schemata::Component::Foo::V12::SCHEMA.validate(old_data)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end

      new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
      new_data.delete("foo2")
      new_data["foo4"] = FOO4_DEFAULT
      new_data
    end

    def generate_old_fields(aux_data = nil)
      return Schemata::Component::V12.new(contents), {}
    end

    #################################################

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
