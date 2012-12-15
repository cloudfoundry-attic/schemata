require 'schemata/cloud_controller/droplet_updated_message'
require 'schemata/cloud_controller/hm_start_request'
require 'schemata/cloud_controller/hm_stop_request'

module Schemata
  module CloudController
    def self.mock_droplet_updated_message(version=DropletUpdatedMessage.current_version)
      DropletUpdatedMessage::const_get("V#{version}").mock
    end

    def self.mock_hm_start_request(version=HmStartRequest.current_version)
      HmStartRequest::const_get("V#{version}").mock
    end

    def self.mock_hm_stop_request(version=HmStopRequest.current_version)
      HmStopRequest::const_get("V#{version}").mock
    end
  end
end
