require 'schemata/common/msgtypebase'

module Schemata
  module HealthManager
    module HealthRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/health_request/*.rb'].each do |file|
  require file
end
