require "schemata/common/msgtypebase"

module Schemata
  module Dea
    module HeartbeatResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/heartbeat_response/*.rb'].each do |file|
  require file
end
