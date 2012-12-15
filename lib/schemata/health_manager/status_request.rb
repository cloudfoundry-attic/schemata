require 'schemata/common/msgtypebase'

module Schemata
  module HealthManager
    module StatusRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/status_request/*.rb'].each do |file|
  require file
end
