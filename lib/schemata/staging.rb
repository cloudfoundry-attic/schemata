require 'schemata/staging/message'

module Schemata
  module Staging
    def self.mock_message(version=Message.current_version)
      Message::const_get("V#{version}").mock
    end
  end
end
