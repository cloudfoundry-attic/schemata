require 'membrane'
require File.expand_path('../../../helpers/hash_copy', __FILE__)

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

    SCHEMA.schemas.keys.each do |k|
      define_method(k.to_sym) do
        Schemata::HashCopyHelpers.deep_copy(@contents[k])
      end

      define_method("#{k}=".to_sym) do |v|
        field_value = Schemata::HashCopyHelpers.deep_copy(v)
        instance_variable_set("@#{k}", field_value)
        @contents[k] = Schemata::HashCopyHelpers.deep_copy(field_value)
        begin
          SCHEMA.schemas[k].validate(@contents[k])
        rescue Membrane::SchemaValidationError => e
          raise Schemata::UpdateAttributeError.new(e.message)
        end
        v
      end
    end

    def self.mock
      mock = {}
      MOCK_VALUES.keys.each do |k|
        value = MOCK_VALUES[k]
        mock[k] = value.respond_to?("call") ? value.call : value
      end
      self.new(mock)
    end

    def initialize(msg_data)
      begin
        SCHEMA.validate(msg_data)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end
      @contents = {}
      SCHEMA.schemas.keys.each do |k|
        field_value = Schemata::HashCopyHelpers.deep_copy(msg_data[k])
        instance_variable_set("@#{k}", field_value)
        @contents[k] = field_value
      end
    end

    def contents
      Schemata::HashCopyHelpers.deep_copy(@contents)
    end

    def message_type
      Schemata::Component::Foo
    end
  end
end
