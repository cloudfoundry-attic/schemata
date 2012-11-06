require 'membrane'
require File.expand_path('../base.rb', __FILE__)
require File.expand_path('../../../helpers/hash_copy', __FILE__)

module Schemata
  module Component
    module Foo
    end
  end
end

module Schemata::Component::Foo
  class V14
    SCHEMA = Membrane::SchemaParser.parse do
      {
        "foo1" => String,
        "foo3" => [Integer],
      }
    end

    AUX_SCHEMA = Membrane::SchemaParser.parse do
      {
        "foo4" => String
      }
    end

    MOCK_VALUES = {
      "foo1" => "foo",
      "foo3" => lambda { [Random.rand(11)] },
    }

    MIN_VERSION_ALLOWED = 13

    def self.upvert(old_data)
      begin
        Schemata::Component::Foo::V13::SCHEMA.validate(old_data)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end

      new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
      new_data.delete("foo4")
      new_data
    end

    def generate_old_fields
      unless @aux_data
        raise Schemata::DecodeError.new("Necessary aux_data missing")
      end
      msg_contents = contents
      msg_contents.update(@aux_data)
      return Schemata::Component::Foo::V13.new(msg_contents), 
        Schemata::HashCopyHelpers.deep_copy(@aux_data)
    end

    #################################################

    def schema
      SCHEMA
    end

    def aux_schema
      AUX_SCHEMA
    end

    def self.mock_values
      MOCK_VALUES
    end

    include Schemata::Component::Foo::Base
    extend Schemata::Component::Foo::Mocking
  end
end
