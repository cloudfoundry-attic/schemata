module Schemata
  class SchemataError < StandardError

    attr_reader :source_exception, :source_backtrace

    def initialize(source_exception = $!, message = nil)
      message = source_exception.message if message.nil? && source_exception
      super(message)
      if source_exception
        @source_exception = source_exception
        @source_backtrace = source_exception.backtrace || []
      end
    end

    def backtrace
      self_backtrace = super
      self_backtrace && source_backtrace  ? self_backtrace + source_backtrace : self_backtrace
    end
  end

  class DecodeError < SchemataError; end
  class EncodeError < SchemataError; end
  class SchemaDefinitionError < SchemataError; end

  class UpdateAttributeError < SchemataError
    attr_reader :key

    def initialize(key, exception = $!)
      super(exception, "#{key}: #{exception.message}")
      @key = key
    end
  end

  class IncompatibleVersionError < SchemataError
    attr_reader :msg_version, :component_version

    def initialize(msg_version, component_version)
      super(self, "min message version #{msg_version} too high for component version #{component_version}")
      @msg_version = msg_version
      @component_version = component_version
    end
  end
end
