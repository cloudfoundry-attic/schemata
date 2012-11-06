module Schemata
  module Component
    module Foo
    end
  end
end

module Schemata::Component::Foo
  module Base

    def initialize(msg_data, aux_data=nil)
      schema.schemas.each do |k, inner_schema|
        self.class.send(:define_method, "#{k}".to_sym) do
          Schemata::HashCopyHelpers.deep_copy(@contents[k])
        end

        self.class.send(:define_method, "#{k}=".to_sym) do |v|
          begin
            inner_schema.validate(v)
          rescue Membrane::SchemaValidationError => e
            raise Schemata::UpdateAttributeError.new(e.message)
          end

          @contents[k] = Schemata::HashCopyHelpers.deep_copy(v)
          v
        end
      end

      if aux_data
        begin
          aux_schema.validate(aux_data)
        rescue Membrane::SchemaValidationError => e
          raise Schemata::EncodeError.new(e.message)
        end

        @aux_data = Schemata::HashCopyHelpers.deep_copy(aux_data)
      end

      @contents = {}
      msg_data.each do |k, v|
        next unless schema.schemas[k]

        begin
          schema.schemas[k].validate(v)
        rescue Membrane::SchemaValidationError => e
          raise Schemata::UpdateAttributeError.new(e.message)
        end

        @contents[k] = Schemata::HashCopyHelpers.deep_copy(v)
      end
    end

    def validate
      schema.validate(@contents)
    end

    def contents
      Schemata::HashCopyHelpers.deep_copy(@contents)
    end

    def aux_data
      Schemata::HashCopyHelpers.deep_copy(@aux_data) if @aux_data
    end

    def message_type
      Schemata::Component::Foo
    end
  end

  module Mocking
    def mock
      mock = {}
      mock_values.keys.each do |k|
        value = mock_values[k]
        mock[k] = value.respond_to?("call") ? value.call : value
      end
      self.new(mock)
    end
  end
end
