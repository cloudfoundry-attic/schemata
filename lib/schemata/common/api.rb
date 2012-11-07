require 'schemata/common/error'
require 'schemata/common/parsed_msg'
require 'yajl'

module Schemata
  module API

    def decode(msg_type, json_msg)
      parsed = Schemata::ParsedMessage.new(json_msg)
      message_version = parsed.version

      curr_version = msg_type.current_version
      curr_class = msg_type.current_class

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
          msg_contents = msg_type::const_get("V#{v}")
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

    def encode(msg_obj)
      begin
        msg_obj.validate_contents
        msg_obj.validate_aux_data
      rescue Membrane::SchemaValidationError => e
        raise Schemata::EncodeError.new(e.message)
      end

      msg_type = msg_obj.message_type
      curr_version = msg_type.current_version
      curr_class = msg_type.current_class

      msg = { "V#{curr_version}" => msg_obj.contents }
      curr_msg_obj = msg_obj
      (curr_class::MIN_VERSION_ALLOWED...curr_version).reverse_each do |v|
        curr_msg_obj, old_fields =
          curr_msg_obj.generate_old_fields
         msg["V#{v}"] = old_fields
      end
      msg["min_version"] = curr_class::MIN_VERSION_ALLOWED
      Yajl::Encoder.encode(msg)
    end
  end
end
