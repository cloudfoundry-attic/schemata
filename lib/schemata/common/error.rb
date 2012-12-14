module Schemata
  class DecodeError < StandardError; end
  class EncodeError < StandardError; end
  class SchemaDefinitionError < StandardError; end

  class UpdateAttributeError < StandardError
    def initialize(key, message)
      super("#{key}: #{message}")
    end
  end

  class IncompatibleVersionError < DecodeError
    def initialize(msg_version, component_version)
      super("min message version #{msg_version} too high for component ver\
sion #{component_version}")
    end
  end
end
