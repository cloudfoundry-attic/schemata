require 'schemata/common/msgtypebase'

module Schemata
  module Dea
    module StartRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/start_request/*.rb'].each do |file|
  require file
end
