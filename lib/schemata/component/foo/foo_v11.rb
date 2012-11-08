require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'

module Schemata
  module Component
    module Foo
      extend Schemata::MessageTypeBase

      version 11 do
        define_schema do
          {
            "foo1" => String,
            "foo2" => Integer,
            "foo3" => Integer,
          }
        end

        define_min_version 10

        define_constant :DEFAULT_FOO3, 1

        define_upvert do |old_data|
          new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
          new_data["foo3"] = self::DEFAULT_FOO3
          new_data
        end

        define_generate_old_fields do |msg_obj|
          {}
        end

        define_constant :MOCK_VALUES, {
          "foo1" => "foo",
          "foo2" => 2,
          "foo3" => 3
        }
      end
    end
  end
end
=begin
module Schemata::Component::Foo
  class V11
    include Schemata::MessageBase

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
  end
end
=end
