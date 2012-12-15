require 'schemata/health_manager/status_request'

module Schemata
  module HealthManager
    def self.mock_status_request(version=StatusRequest.current_version)
      StatusRequest::const_get("V#{version}").mock
    end
  end
end
