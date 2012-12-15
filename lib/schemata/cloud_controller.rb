require 'schemata/cloud_controller/droplet_updated_message'

module Schemata
  module CloudController
    def self.mock_droplet_updated_message(version=DropletUpdatedMessage.current_version)
      DropletUpdatedMessage::const_get("V#{version}").mock
    end
  end
end
