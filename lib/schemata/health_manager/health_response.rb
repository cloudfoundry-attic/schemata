require 'schemata/common/msgtypebase'

module Schemata
  module HealthManager
    module HealthResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/health_response/*.rb'].each do |file|
  require file
end
