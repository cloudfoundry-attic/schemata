require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module StopRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/stop_request/*.rb'].each do |file|
  require file
end
