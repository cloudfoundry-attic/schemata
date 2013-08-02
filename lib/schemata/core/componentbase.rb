require 'schemata/core/naming_constants'
require 'schemata/helpers/decamelize'

module Schemata
  module ComponentBase

    def message_types
      self.constants.select { |x| x != :VERSION }
    end

    def component_name
      self.name.split("::")[Schemata::NamingConstants.component_name_index]
    end

    def eigenclass
      class << self; self; end
    end

    def register_mock_methods
      message_types.each do |type|
        message_type = self::const_get(type)
        mock_method_name = "mock_#{Schemata::Helpers.decamelize(type.to_s)}"
        eigenclass.send(:define_method, mock_method_name) do |*args|
          version = args[0] || message_type.current_version
          message_type::const_get("V#{version}").mock
        end
      end
    end

    def require_message_classes
      path = [
        File.expand_path("../../", __FILE__),
        "/",
        Schemata::Helpers.decamelize(component_name),
        "/*.rb"
      ].join
      Dir.glob(path, &method(:require))
    end

    def self.extended(mod)
      mod.require_message_classes
      mod.register_mock_methods
    end
  end
end
