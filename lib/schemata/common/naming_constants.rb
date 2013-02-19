module Schemata
  module NamingConstants
    # Components are named with the format: "Schemata::ComponentName::MessageType::Version".

    def self.component_name_index
      1
    end

    def self.message_type_index
      2
    end

    def self.version_index
      3
    end
  end
end