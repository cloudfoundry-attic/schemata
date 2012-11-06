module Schemata
  module Component
    module Foo
    end
  end
end

module Schemata::Component::Foo
  module Base

    class ValidatingContainer
      def initialize(schema, data = {})
        data ||= {}
        @schema = schema
        @contents = {}

        @schema.schemas.each do |key, field_schema|
          self.class.send(:define_method, "#{key}".to_sym) do
            if @contents[key]
              return Schemata::HashCopyHelpers.deep_copy(@contents[key])
            end

            nil
          end

          self.class.send(:define_method, "#{key}=".to_sym) do |field_value|
            begin
              field_schema.validate(field_value)
            rescue Membrane::SchemaValidationError => e
              raise Schemata::UpdateAttributeError.new(e.message)
            end

            @contents[key] = Schemata::HashCopyHelpers.deep_copy(field_value)
            field_value
          end
        end

        data.each do |key, field_value|
          field_schema = @schema.schemas[key]
          next unless field_schema

          begin
            field_schema.validate(field_value)
          rescue Membrane::SchemaValidationError => e
            raise Schemata::UpdateAttributeError.new(e.message)
          end

          @contents[key] = Schemata::HashCopyHelpers.deep_copy(field_value)
        end
      end

      def contents
        Schemata::HashCopyHelpers.deep_copy(@contents)
      end

      def empty?
        @contents.empty?
      end

      def validate
        @schema.validate(@contents)
      end
    end

    def initialize(msg_data_hash, aux_data_hash = nil)
      @contents = ValidatingContainer.new(schema, msg_data_hash)
      if aux_schema
        @aux_contents = ValidatingContainer.new(aux_schema, aux_data_hash)
      end

      schema.schemas.each do |key, field_schema|
        self.class.send(:define_method, "#{key}".to_sym) do
          @contents.send("#{key}".to_sym)
        end

        self.class.send(:define_method, "#{key}=".to_sym) do |field_value|
          @contents.send("#{key}=".to_sym, field_value)
        end
      end
    end

    def validate_contents
      @contents.validate
    end

    def validate_aux_data
      @aux_contents.validate if aux_schema
    end

    def schema
      component, klass, version = self.class.name.split("::")[-3..-1]
      Schemata::const_get(component)::const_get(klass)::
        const_get(version)::SCHEMA
    end

    def aux_schema
      component, klass, version = self.class.name.split("::")[-3..-1]
      begin
        Schemata::const_get(component)::const_get(klass)::
          const_get(version)::AUX_SCHEMA
      rescue NameError
        nil
      end
    end

    def contents
      @contents.contents
    end

    def aux_data
      @aux_contents
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

    def mock_values
      component, klass, version = self.name.split("::")[-3..-1]
      Schemata::const_get(component)::const_get(klass)::
        const_get(version)::MOCK_VALUES
    end
  end
end
