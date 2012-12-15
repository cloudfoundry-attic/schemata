require 'schemata/health_manager/status_request'
require 'schemata/health_manager/status_flapping_response'
require 'schemata/health_manager/status_crashed_response'

module Schemata
  module HealthManager
    def self.mock_status_request(version=StatusRequest.current_version)
      StatusRequest::const_get("V#{version}").mock
    end

    def self.mock_status_flapping_response(version=StatusFlappingResponse.current_version)
      StatusFlappingResponse::const_get("V#{version}").mock
    end

    def self.mock_status_crashed_response(version=StatusCrashedResponse.current_version)
      StatusCrashedResponse::const_get("V#{version}").mock
    end
  end
end
