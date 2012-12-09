require 'schemata/dea/heartbeat_response'
require 'schemata/dea/find_droplet_response'
require 'schemata/dea/droplet_status_response'

module Schemata
  module DEA
    def self.mock_heartbeat_response(version=HeartbeatResponse.current_version)
      HeartbeatResponse::const_get("V#{version}").mock
    end

    def self.mock_find_droplet_response(version=FindDropletResponse.current_version)
      FindDropletResponse::const_get("V#{version}").mock
    end

    def self.mock_droplet_status_response(version=DropletStatusResponse.current_version)
      DropletStatusResponse::const_get("V#{version}").mock
    end
  end
end
