require 'schemata/common/msgbase'
require 'schemata/common/parsed_msg'

module Schemata
  module MessageTypeBase
    def current_version
      return @current_version if @current_version
      @current_version = versions.max
    end

    def versions
      str_versions = self.constants.select { |x| x =~ /^V[0-9]+$/ }
      str_versions.map { |x| x[1..-1].to_i}
    end

    def current_class
      self::const_get("V#{current_version}")
    end

    def decode(json_msg)
      begin
        parsed = Schemata::ParsedMessage.new(json_msg)
      rescue Schemata::DecodeError => e
        raise e unless versions.size == 1
        return decode_raw_payload(json_msg)
      end
      message_version = parsed.version

      curr_version = current_version
      curr_class = current_class

      if curr_version < parsed.min_version
        # TODO - Perhaps we should add
        #   || message_version < msg_type::Current::MIN_VERSION_ALLOWED
        raise IncompatibleVersionError.new(
          parsed.min_version,
          curr_version)
      end

      msg_contents = parsed.contents["V#{message_version}"]
      if curr_version <= message_version
        (message_version - 1).downto(curr_version) do |v|
          msg_contents.update(parsed.contents["V#{v}"])
        end
      else
        (message_version + 1).upto(curr_version) do |v|
          msg_contents = const_get("V#{v}")
            .upvert(msg_contents)
        end
      end

      begin
        msg_obj = curr_class.new(msg_contents)
        msg_obj.validate_contents
        # We don't validate aux data in decode.
        return msg_obj
      rescue Schemata::UpdateAttributeError => e
        raise Schemata::DecodeError.new(e.message)
      rescue Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end
    end

    def self.extended(o)
      o.extend Dsl
    end

    module Dsl
      def version(v, &blk)
        klass = Class.new
        klass.instance_eval do
          def eigenclass
            class << self; self; end
          end
        end
        klass.send(:include, Schemata::MessageBase)
        klass.instance_eval(&blk)

        if !defined? klass::INCLUDE_PRESCHEMATA
          klass.const_set(:INCLUDE_PRESCHEMATA, false)
        end

        # Create the necessary ValidatingContainer subclasses (one for schema
        # and, optionally, one for aux_schema
        klass.instance_eval do
          vc_klass = self::ValidatingContainer.define(self.schema)
          self.const_set(:VC_KLASS, vc_klass)
          if self.aux_schema
            aux_vc_klass = self::ValidatingContainer.define(self.aux_schema)
            self.const_set(:AUX_VC_KLASS, aux_vc_klass)
          end
        end

        # Define attribute accessors for the message class
        klass.schema.schemas.each do |key, field_schema|
          klass.send(:define_method, key) do
            @contents.send(key)
          end
          klass.send(:define_method, "#{key}=") do |field_value|
            @contents.send("#{key}=", field_value)
          end
        end
        self::const_set("V#{v}", klass)
      end
    end

    private

    def decode_raw_payload(json)
      begin
        msg_contents = Yajl::Parser.parse(json)
        msg_obj = current_class.new(msg_contents)
        msg_obj.validate_contents
        return msg_obj
      rescue Schemata::UpdateAttributeError,
        Membrane::SchemaValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end
    end

  end
end
