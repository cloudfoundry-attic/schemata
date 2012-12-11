require 'schemata/router/register_request'
require 'schemata/router/start_message'

module Schemata
  module Router
    def self.mock_register_request(version=RegisterRequest.current_version)
      RegisterRequest::const_get("V#{version}").mock
    end

    def self.mock_start_message(version=StartMessage.current_version)
      StartMessage::const_get("V#{version}").mock
    end
  end
end
