require 'yajl'
require 'membrane'
require 'schemata/common/error'

module Schemata
  module MessageBase

    class ValidatingContainer
      def initialize(data = {})
        data ||= {}
        @schema = self.class.const_get(:SCHEMA)
        @contents = {}

        data.each do |key, field_value|
          field_schema = @schema.schemas[key]
          next unless field_schema

          # TODO This call to stringify should be removed when cc/dea stop using
          # Symbols.
          #
          # Currently, some fields (for example, 'states' in requests sent
          # on dea.find.droplet), are are symbols, During Yajl decoding, however,
          # they become strings. Thus, on the encoding side, Schemata should expect
          # symbols, but on the decoding side, it should expect strings. To allow
          # for this in the schema definition, Schemata stringifies all symbols during
          # construction of Schemata objects.
          field_value = Schemata::HashCopyHelpers.stringify(field_value)

          begin
            field_schema.validate(field_value)
          rescue Membrane::SchemaValidationError => e
            raise Schemata::UpdateAttributeError.new(e.message)
          end

          @contents[key] = Schemata::HashCopyHelpers.deep_copy(field_value)
        end
      end

      def self.define(schema)
        vc_klass = Class.new(self)
        vc_klass.const_set(:SCHEMA, schema)
        schema.schemas.each do |key, field_schema|
          vc_klass.send(:define_method, key) do
            unless @contents[key].nil?
              return Schemata::HashCopyHelpers.deep_copy(@contents[key])
            end
            nil
          end

          # TODO This call to stringify should be removed when cc/dea stops using
          # symbols. See comment above for a better description.
          vc_klass.send(:define_method, "#{key}=") do |field_value|
            field_value = Schemata::HashCopyHelpers.stringify(field_value)
            begin
              field_schema.validate(field_value)
            rescue Membrane::SchemaValidationError => e
              raise Schemata::UpdateAttributeError.new(e.message)
            end
            @contents[key] = Schemata::HashCopyHelpers.deep_copy(field_value)
            field_value
          end
        end
        vc_klass
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

    def vc_klass
      self.class.const_get(:VC_KLASS)
    end

    def aux_vc_klass
      return self.class.const_get(:AUX_VC_KLASS) if self.class.aux_schema
    end

    def initialize(msg_data_hash = nil, aux_data_hash = nil)
      @contents = vc_klass.new(msg_data_hash)
      if self.class.aux_schema
        @aux_contents = aux_vc_klass.new(aux_data_hash)
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
      curr_version = self.class.version
      min_version = self.class::MIN_VERSION_ALLOWED

      msg = { "V#{curr_version}" => contents }
      curr_msg_obj = self
      (min_version...curr_version).reverse_each do |v|
        curr_msg_obj, old_fields =
          curr_msg_obj.generate_old_fields
         msg["V#{v}"] = old_fields
      end
      msg["min_version"] = min_version

      if include_preschemata?
        msg["V#{curr_version}"].each do |k, v|
          msg[k] = v
        end
      end
      Yajl::Encoder.encode(msg)
    end

    def include_preschemata?
      self.class.const_get(:INCLUDE_PRESCHEMATA)
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

    def component
      _, component, msg_type, version = self.class.name.split("::")
      Schemata::const_get(component)
    end

    def self.included(klass)
      klass.extend(Schemata::ClassMethods)
      klass.extend(Dsl)
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
      schema = Membrane::SchemaParser.parse(&blk)
      unless schema.kind_of? Membrane::Schema::Record
        Schemata::SchemaDefinitionError.new("Schema must be a hash")
      end
      self::const_set(:SCHEMA, schema)
    end

    def define_aux_schema(&blk)
      aux_schema = Membrane::SchemaParser.parse(&blk)
      unless aux_schema.kind_of? Membrane::Schema::Record
        Schemata::SchemaDefinitionError.new("Schema must be a hash")
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

    def define_mock_values(hash=nil, &blk)
      if (hash && blk) ||  (!hash && !blk)
        # value defined twice or not at all
        raise SchemaDefinitionError.new("Mock values incorrectly defined")
      end

      hash = blk.call if blk

      # Validate a sample of the mock values.
      mock = {}
      hash.each do |key, value|
        mock[key] = value.respond_to?("call") ? value.call : value
      end

      begin
        self.schema.validate(mock)
        define_constant(:MOCK_VALUES, hash)
      rescue Membrane::SchemaValidationError => e
        raise SchemaDefinitionError.new("Sample mock values do not match schema: #{e}")
      end
    end

    def define_constant(constant_name, constant_value)
      self.const_set(constant_name, constant_value)
    end

    def include_preschemata
      define_constant(:INCLUDE_PRESCHEMATA, true)
    end

  end
end
