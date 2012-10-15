require 'membrane'

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

      new_data = old_data.dup
      new_data.delete("foo2")
      new_data["foo4"] = FOO4_DEFAULT
      new_data
    end

    def generate_old_fields(aux_data = nil)
      return Schemata::Component::V12.new(@contents), {}
    end

    #################################################

    SCHEMA.schemas.keys.each do |k|
      attr_reader k.to_sym
      define_method("#{k}=".to_sym) do |v|
        instance_variable_set("@#{k}", v)
        @contents[k] = v
        begin
          SCHEMA.validate @contents
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
