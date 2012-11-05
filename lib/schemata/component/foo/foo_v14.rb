require 'membrane'
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

    SCHEMA.schemas.keys.each do |k|
      define_method(k.to_sym) do
        Schemata::HashCopyHelpers.deep_copy(@contents[k])
      end

      define_method("#{k}=".to_sym) do |v|
        field_values = Schemata::HashCopyHelpers.deep_copy(v)
        instance_variable_set("@#{k}", field_value)
        @contents[k] = field_value
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

    def initialize(msg_data, aux_data = nil)
      begin
        SCHEMA.validate(msg_data)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end

      if aux_data
        begin
          AUX_SCHEMA.validate(aux_data)
        rescue Membrane::SchemaValidationError => e
          raise Schemata::EncodeError.new(e.message)
        end

        @aux_data = Schemata::HashCopyHelpers.deep_copy(aux_data)
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
