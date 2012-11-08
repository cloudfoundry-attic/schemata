require 'schemata/common/error'

module Schemata
  module MessageBase

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
      @contents = ValidatingContainer.new(self.class.schema, msg_data_hash)
      if self.class.aux_schema
        @aux_contents = ValidatingContainer.new(self.class.aux_schema,
                                                aux_data_hash)
      end

      self.class.schema.schemas.each do |key, field_schema|
        self.class.send(:define_method, "#{key}".to_sym) do
          @contents.send("#{key}".to_sym)
        end

        self.class.send(:define_method, "#{key}=".to_sym) do |field_value|
          @contents.send("#{key}=".to_sym, field_value)
        end
      end
    end

    def encode
      begin
        validate_contents
        validate_aux_data
      rescue Membrane::SchemaValidationError => e
        raise Schemata::EncodeError.new(e.message)
      end

      msg_type = message_type
      curr_version = msg_type.current_version
      min_version = self.class::MIN_VERSION_ALLOWED

      msg = { "V#{curr_version}" => contents }
      curr_msg_obj = self
      (min_version...curr_version).reverse_each do |v|
        curr_msg_obj, old_fields =
          curr_msg_obj.generate_old_fields
         msg["V#{v}"] = old_fields
      end
      msg["min_version"] = min_version
      Yajl::Encoder.encode(msg)
    end

    def validate_contents
      @contents.validate
    end

    def validate_aux_data
      @aux_contents.validate if self.class.aux_schema
    end

    def contents
      @contents.contents
    end

    def aux_data
      @aux_contents
    end

    def message_type
      _, component, msg_type, version = self.class.name.split("::")
      Schemata::const_get(component)::const_get(msg_type)
    end

    def self.included(klass)
      klass.extend(Schemata::ClassMethods)
      klass.extend Dsl
    end
  end

  module ClassMethods
    def mock
      mock = {}
      mock_values.keys.each do |k|
        value = mock_values[k]
        mock[k] = value.respond_to?("call") ? value.call : value
      end
      self.new(mock)
    end

    def schema
      self::SCHEMA
    end

    def aux_schema
      return self::AUX_SCHEMA if defined?(self::AUX_SCHEMA)
    end

    def mock_values
      self::MOCK_VALUES
    end

    def version
      _, component, msg_type, version = self.name.split("::")
      version[1..-1].to_i
    end

    def previous_version
      _, component, msg_type, version = self.name.split("::")
      version = version[1..-1].to_i - 1
      Schemata::const_get(component)::const_get(msg_type)::
        const_get("V#{version}")
    end
  end

  module Dsl
    def define_schema(&blk)
      res = blk.call
      unless res.instance_of? Hash
        raise Schemata::SchemaDefinitionError.new("Schema must be a hash")
      end

      schema = Membrane::SchemaParser.parse do
        res
      end
      self::const_set(:SCHEMA, schema)
    end

    def define_aux_schema(&blk)
      res = blk.call
      unless res.instance_of? Hash
        raise Schemata::SchemaDefinitionError.new("Schema must be a hash")
      end

      aux_schema = Membrane::SchemaParser.parse do
        res
      end
      self::const_set(:AUX_SCHEMA, aux_schema)
    end

    def define_min_version(min_version)
      unless min_version.is_a? Integer
        raise SchemaDefinitionError.new("Min version must be an integer")
      end
      const_set(:MIN_VERSION_ALLOWED, min_version)
    end

    def define_upvert(&blk)
      eigenclass.send(:define_method, :upvert) do |old_data|
        # No need to validate aux_data because upvert is only called during
        # decode, when aux_data is irrelevant
        begin
          previous_version::SCHEMA.validate(old_data)
        rescue Membrane::SchemaValidationError => e
          raise Schemata::DecodeError.new(e.message)
        end

        blk.call(old_data)
      end
    end

    def define_generate_old_fields(&blk)
      self.send(:define_method, :generate_old_fields) do
        if self.class.aux_schema && aux_data.empty?
          raise Schemata::DecodeError.new("Necessary aux_data missing")
        end
        old_fields = blk.call(self)

        msg_contents = contents
        msg_contents.update(old_fields)
        msg_obj = self.class.previous_version.new(msg_contents)

        msg_obj.validate_contents
        return msg_obj, old_fields
      end
    end

    def define_constant(constant_name, constant_value)
      self.const_set(constant_name, constant_value)
    end
  end
end
