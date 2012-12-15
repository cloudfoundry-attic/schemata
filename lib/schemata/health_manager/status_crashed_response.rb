require 'schemata/common/msgtypebase'

module Schemata
  module HealthManager
    module StatusCrashedResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/status_crashed_response/*.rb'].each do |file|
  require file
end
