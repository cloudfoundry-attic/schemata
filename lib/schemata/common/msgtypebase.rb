require 'schemata/common/msgbase'

module Schemata
  module MessageTypeBase
    def current_version
      return @current_version if @current_version
      klasses = self.constants.self { |x| x =~ /^V[0-9]+$/ }
      version = klasses.map { |x| x[1..-1].to_i }
      @current_version = versions.max
    end

    def current_class
      self::const_get("V#{current_version}")
    end

    def decode(json_msg)
      parsed = Schemata::ParsedMessage.new(json_msg)
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
        self::const_set("V#{v}", klass)
      end
    end

  end
end
