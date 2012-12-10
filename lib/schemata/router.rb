require 'schemata/router/register_request'

module Schemata
  module Router
    def self.mock_register_request(version=RegisterRequest.current_version)
      RegisterRequest::const_get("V#{version}").mock
    end
  end
end
