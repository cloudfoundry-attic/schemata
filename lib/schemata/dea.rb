require 'schemata/dea/heartbeat_response'
require 'schemata/dea/find_droplet_request'
require 'schemata/dea/find_droplet_response'
require 'schemata/dea/droplet_status_response'
require 'schemata/dea/advertise_message'
require 'schemata/dea/hello_message'
require 'schemata/dea/dea_status_response'
require 'schemata/dea/exit_message'
require 'schemata/dea/discover_request'
require 'schemata/dea/start_request'
require 'schemata/dea/stop_request'
require 'schemata/dea/update_request'

module Schemata
  module DEA
    def self.mock_heartbeat_response(version=HeartbeatResponse.current_version)
      HeartbeatResponse::const_get("V#{version}").mock
    end

    def self.mock_find_droplet_request(version=FindDropletRequest.current_version)
      FindDropletRequest::const_get("V#{version}").mock
    end

    def self.mock_find_droplet_response(version=FindDropletResponse.current_version)
      FindDropletResponse::const_get("V#{version}").mock
    end

    def self.mock_droplet_status_response(version=DropletStatusResponse.current_version)
      DropletStatusResponse::const_get("V#{version}").mock
    end

    def self.mock_advertise_message(version=AdvertiseMessage.current_version)
      AdvertiseMessage::const_get("V#{version}").mock
    end

    def self.mock_hello_message(version=HelloMessage.current_version)
      HelloMessage::const_get("V#{version}").mock
    end

    def self.mock_dea_status_response(version=DeaStatusResponse.current_version)
      DeaStatusResponse::const_get("V#{version}").mock
    end

    def self.mock_exit_message(version=ExitMessage.current_version)
      ExitMessage::const_get("V#{version}").mock
    end

    def self.mock_discover_request(version=DiscoverRequest.current_version)
      DiscoverRequest::const_get("V#{version}").mock
    end

    def self.mock_start_request(version=StartRequest.current_version)
      StartRequest::const_get("V#{version}").mock
    end

    def self.mock_stop_request(version=StopRequest.current_version)
      StopRequest::const_get("V#{version}").mock
    end

    def self.mock_update_request(version=UpdateRequest.current_version)
      UpdateRequest::const_get("V#{version}").mock
    end
  end
end
