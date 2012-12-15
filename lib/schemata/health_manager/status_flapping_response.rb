require 'schemata/common/msgtypebase'

module Schemata
  module HealthManager
    module StatusFlappingResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/status_flapping_response/*.rb'].each do |file|
  require file
end
