require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module DeaStatusResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/dea_status_response/*.rb'].each do |file|
  require file
end
