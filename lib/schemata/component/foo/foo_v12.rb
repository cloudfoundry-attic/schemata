require 'membrane'

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
      new_data = old_data.dup
      new_data["foo3"] = [old_data["foo3"]]
      new_data
    end

    def generate_old_fields(aux_data = nil)
      first = @foo3.length > 0 ? @foo3[0] : 1
      old_fields = { "foo3" => first }

      old_contents = @contents.dup
      old_fields.each do |k, v|
        old_contents[k] = v
      end
      old_msg = Schemata::Component::Foo::V11.new(old_contents)
      return old_msg, old_fields
    end

  #############################################

    SCHEMA.schemas.keys.each do |k|
      attr_reader k.to_sym
      define_method("#{k}=".to_sym) do |v|
        instance_variable_set("@#{k}", v)
        @contents[k] = v
        begin
          SCHEMA.validate(@contents)
        rescue Membrane::SchemaValidationError => e
          raise Schemata::UpdateAttributeError.new(e.message)
        end
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

      @contents = msg_data.dup
      SCHEMA.schemas.keys.each do |k|
        instance_variable_set("@#{k}", msg_data[k])
      end
    end

    def contents
      @contents.dup
    end

    def message_type
      Schemata::Component::Foo
    end
  end
end
