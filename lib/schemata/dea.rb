require 'schemata/dea/heartbeat_response'
require 'schemata/dea/find_droplet_response'
require 'schemata/dea/droplet_status_response'
require 'schemata/dea/advertise_message'
require 'schemata/dea/hello_message'
require 'schemata/dea/dea_status_response'
require 'schemata/dea/exit_message'

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
  end
end
