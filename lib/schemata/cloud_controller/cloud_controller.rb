require 'schemata/cloud_controller/bar'
require 'schemata/common/api'

module Schemata
  module CloudController
    extend API

    def self.mock_bar(version=Bar.current_version)
      Bar::const_get("V#{version}").mock
    end
  end
end
