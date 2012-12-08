require 'schemata/dea/heartbeat_response'

module Schemata
  module DEA
    def self.mock_heartbeat_response(version=HeartbeatResponse.current_version)
      HeartbeatResponse::const_get("V#{version}").mock
    end
  end
end
