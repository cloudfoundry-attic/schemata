require 'schemata/cloud_controller/bar'

module Schemata
  module CloudController

    def self.mock_bar(version=Bar.current_version)
      Bar::const_get("V#{version}").mock
    end
  end
end
